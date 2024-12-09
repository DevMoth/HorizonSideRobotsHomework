using HorizonSideRobots

#основные функции со сторонами
function rotate(side, steps)#поворот стороны на steps шагов против часовой(если отрицательное число, то по часовой)
    side = Int(side)+steps
    if side >= 0
        return HorizonSide(side%4)
    else
        return HorizonSide(4+side) 
    end
end
Base.:+(side::HorizonSide, x::Integer) = rotate(side, x)#перегрузки операторов + и - для HorizonSide
Base.:-(side::HorizonSide, x::Integer) = rotate(side, -1*x)
function Base.:+(sides::NTuple{2, HorizonSide}, x::Integer)
    return (sides[1]+x, sides[2]+x)
end
function Base.:-(sides::NTuple{2, HorizonSide}, x::Integer)
    return (sides[1]-x, sides[2]-x)
end
function get_borders(robot)#возвращает список всех стен, которых касается робот
    borders = []
    for side in [Ost, Sud, West, Nord]
        if isborder(robot, side)
            push!(borders, side)
        end
    end
    return borders
end

#перегрузки для ходьбы по диагонали
function HorizonSideRobots.isborder(robot, sides::Tuple; strict = false)#перегрузка isborder для массивов сторон(если strict = true, то должны быть все стороны, иначе хотя бы одна)
    for side in sides 
        if strict && !isborder(robot, side)
            return false
        end
        if !strict && isborder(robot, side)
            return true
        end
    end
    return strict
end
function HorizonSideRobots.move!(robot, sides::Tuple)#перегрузка move! для массива сторон
    for side in sides 
        move!(robot, side)
    end
end

#основные функции ходьбы
function move_steps!(robot, side, steps = 1; breakFunc = ()->false)#двигается steps шагов, до стены или до выполнения breakFunc()
    counter = 0
    for _ in 1:steps 
        if isborder(robot, side) || breakFunc()
            return counter#не прошел steps шагов
        end
        move!(robot, side)
        counter += 1
    end
    return counter#возвращает кол-во пройденных шагов(здесь == steps)
end
function move_until!(stop_condition::Function, robot, side)#двигается до того, как stop_condition возвращает true
    n=0
    while !stop_condition()
        move!(robot, side)
        n+=1
    end
    return n
end

#обертка робота для покраски
struct Paint#обертка робота, ставящая маркеры при движении
    robot
end
function HorizonSideRobots.move!(robot::Paint, side)
    move!(robot.robot, side)
    putmarker!(robot)
end
function HorizonSideRobots.move!(robot::Paint, sides::Tuple)#перегрузка move! для маляра и массива сторон. сначала проходит все стороны, а потом ставит маркер
    for side in sides 
        move!(robot.robot, side)
    end
    putmarker!(robot)
end
function HorizonSideRobots.putmarker!(robot::Paint)
    putmarker!(robot.robot)
end
function HorizonSideRobots.isborder(robot::Paint, side)
    return isborder(robot.robot, side)
end
function HorizonSideRobots.ismarker(robot::Paint)
    return ismarker(robot.robot)
end

#функции для передвижения в угол и домой
function move_to_corner!(robot, corner = (Nord, West))#передвигает робота в угол; возвращает список шагов чтобы вернуться домой
    moves = []
    while true
        for side in corner
            move = (side, move_until!(()->isborder(robot, side), robot, side))
            push!(moves, move)
            if issubset(corner, get_borders(robot))
                return moves
            end
        end
    end
end
function execute_path!(robot, path; reversePath = false)#выполняет список шагов; шаг = (сторона света; кол-во шагов)
    if !reversePath
        for cmd in path
            move_steps!(robot, cmd[1], cmd[2])
        end
    else
        for cmd in reverse(path)
            move_steps!(robot, cmd[1]+2, cmd[2])
        end
    end
end
function return_home!(robot, moves, corner = (Nord, West))#возвращается домой из любой клетки поля(moves- список шагов из дома в угол)
    move_to_corner!(robot, corner)
    execute_path!(robot, moves, reversePath = true)
end

#основные функции узоров
function cross!(robot, side)#строит крест в 4 направления, начиная с данного
    for i in 0:3
        steps = move_until!(()->isborder(robot, side+i), Paint(robot), side+i)
        move_steps!(robot, side+i+2, steps)
    end
end
function perimeter!(robot, side)#обходит внешнюю стену по периметру
    for i in 0:3
        move_until!(()->isborder(robot, side-i), robot, side-i)
    end
end
function snake!(stop_condition::Function, robot, sides::NTuple{2,HorizonSide})#двигается змейкой по заданным сторонам и останавливается, когда stop_condition возвращает true
    s=sides[1]
    while !stop_condition()
        move_until!(()->stop_condition() || isborder(robot, s), robot,s)
        if stop_condition()
            break
        end
        s = s+2
        move!(robot, sides[2])
    end
end
function spiral!(stop_condition::Function, robot)#идет по спирали пока stop_condition не вернет true
    steps = 1
    side = Nord
    while true
        side = side+1
        move_steps!(robot, side, steps, breakFunc = stop_condition)
        if stop_condition()
            break
        end
        side = side+1
        move_steps!(robot, side, steps, breakFunc = stop_condition)
        if stop_condition()
            break
        end
        steps += 1
    end
end

#простые функции обхода стен
function shuttle!(stop_condition::Function, robot, side)#шатается влево-вправо, пока stop_condition не вернет true; возвращает сторону и кол-во шагов
    steps = 0
    while !stop_condition() 
        move_steps!(robot, side, steps)
        if stop_condition()
            break
        end
        side = side + 2
        steps += 1
    end
    return (side, ceil(steps/2))
end
function shuttle_for_walls!(stop_condition::Function, robot, side)#shuttle! с учетом стен
    metWall = false
    addStep = false
    steps = 0
    while !stop_condition() 
        walked = move_steps!(robot, side, steps)
        if stop_condition()
            break
        end
        move_steps!(robot, side+2, walked)
        if walked != steps
            if metWall
                return (side, 0)
            end
            metWall = true
        end

        if addStep
            steps += 1
        end
        addStep = !addStep

        if !metWall
            side = side+2
        end
    end
    return (side, steps)
end
function move_around_wall!(robot, side)#обходит стену при помощи shuttle!
    if !isborder(robot, side)
        move!(robot, side)
        return 1
    end
    path = shuttle_for_walls!(()->!isborder(robot, side), robot, side+1)
    move_steps!(robot, side, 1)
    steps = move_until!(()->!isborder(robot, path[1]+2)||isborder(robot, side), robot, side)+1
    move_steps!(robot, path[1]+2, path[2])
    return steps
end
function move_steps_with_nav!(robot, side, steps; breakFunc = ()->false)#идет steps шагов, обходит стены
    n = steps
    while n > 0 && !breakFunc()
        walked = move_around_wall!(robot, side)
        if walked == 0
            break
        else
            n -= walked
        end
    end
    return steps - n
end

#узоры для обхода стен
function snake_with_nav!(robot, sides)# проходит все поле, но может обходить внутренние стены
    side = sides[1]
    height = move_until!(()->isborder(robot, side), robot, side)
    side = rotate(side, 2)
    while true
        move_steps_with_nav!(robot, side, height)
        if !isborder(robot, sides[2])
            move!(robot, sides[2])
        else
            break
        end
        side = rotate(side, 2)
    end
end
function spiral_with_nav!(stop_condition::Function, robot)#spiral! но с обходом стен
    steps = 1
    side = Nord
    while true
        side = rotate(side,1)
        move_steps_with_nav!(robot, side, steps, breakFunc = stop_condition)
        println((side, steps))
        if stop_condition()
            break
        end
        side = rotate(side,1)
        move_steps_with_nav!(robot, side, steps, breakFunc = stop_condition)
        println((side, steps))
        if stop_condition()
            break
        end
        steps += 1
    end
end