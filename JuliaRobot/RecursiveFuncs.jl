using HorizonSideRobots
function recMoveUntilWall(robot, side, steps = 0)#двигается до стены через рекурсию, возвращает пройденные шаги
    if isborder(robot, side)
        return steps
    else
        move!(robot, side)
        recMoveUntilWall(robot, side, steps+1)
    end
end
function recMoveSteps(robot, side, steps)#идет на steps шагов вперед через рекурсию, возвращает смог ли он пройти 
    if steps == 0
        return true
    elseif isborder(robot, side)
        return false
    else
        move!(robot, side)
        steps -= 1
        recMoveSteps(robot, side, steps)
    end
end
function recWallNav(robot, side, sideStep = [rotate(side, 1), 0])#обход стены через рекурсию
    if !isborder(robot, side)
        move!(robot, side)
        recMoveSteps(robot, rotate(sideStep[1], 2), ceil(sideStep[2]/2))
    else
        sideStep[1] = rotate(sideStep[1], 2)
        sideStep[2] += 1
        recMoveSteps(robot, sideStep[1], sideStep[2])
        recWallNav(robot, side, sideStep)
    end
end

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
function getFreeSides(robot)#возвращает все стороны без стен
    sides = []
    for side in [Nord, Ost, Sud, West]
        if !isborder(robot, side)
            push!(sides, side)
        end
    end
    return sides
end
function walkLabyrinth(robot; isGoodSide = (side)->!isborder(robot, side))#рекурсивная функция, обходит любой лабиринт
    if (robot.x, robot.y) in robot.coords
        return false
    end
    for side in [Nord, Ost, Sud, West]
        if isGoodSide(side)
            move!(robot, side)
            walkLabyrinth(robot)
            move!(robot, rotate(side, 2))
        end
    end
end