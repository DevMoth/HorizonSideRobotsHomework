using HorizonSideRobots

#основные рек. функции
function rec_move_until_wall!(robot, side, steps = 0)#двигается до стены через рекурсию, возвращает пройденные шаги
    if isborder(robot, side)
        return steps
    else
        move!(robot, side)
        rec_move_until_wall!(robot, side, steps+1)
    end
end
function rec_move_steps!(robot, side, steps)#идет на steps шагов вперед через рекурсию, возвращает смог ли он пройти 
    if steps == 0
        return true
    elseif isborder(robot, side)
        return false
    else
        move!(robot, side)
        steps -= 1
        rec_move_steps!(robot, side, steps)
    end
end
function rec_move_around_wall!(robot, side, sideStep = [rotate(side, 1), 0])#обход стены через рекурсию
    if !isborder(robot, side)
        move!(robot, side)
        rec_move_steps!(robot, rotate(sideStep[1], 2), ceil(sideStep[2]/2))
    else
        sideStep[1] = rotate(sideStep[1], 2)
        sideStep[2] += 1
        rec_move_steps!(robot, sideStep[1], sideStep[2])
        rec_move_around_wall(robot, side, sideStep)
    end
end

#лабиринт
mutable struct LabBot# робот с координатами и списком всех пройденных клеток
    robot
    x::Int
    y::Int
    coords
end
LabBot(robot) = LabBot(robot, 0, 0, Set())#конструктор робота
function HorizonSideRobots.move!(robot::LabBot, side)#перегрузка move! для LabBot
    push!(robot.coords, (robot.x, robot.y))
    if side == Nord
        robot.y -= 1
    elseif side == Sud
        robot.y += 1
    elseif side == West
        robot.x -= 1
    elseif side == Ost
        robot.x += 1
    end
    move!(robot.robot, side)
end
function HorizonSideRobots.putmarker!(robot::LabBot)#перегрузка putmarker! для LabBot
    putmarker!(robot.robot)
end
function HorizonSideRobots.isborder(robot::LabBot, side)#перегрузка isborder для LabBot
    return isborder(robot.robot, side)
end
function walk_labyrinth!(robot; isGoodSide = (side)->!isborder(robot, side))#рекурсивная функция, обходит любой лабиринт
    if (robot.x, robot.y) in robot.coords
        return false
    end
    for side in [Nord, Ost, Sud, West]
        if isGoodSide(side)
            move!(robot, side)
            walk_labyrinth!(robot)
            move!(robot, rotate(side, 2))
        end
    end
end