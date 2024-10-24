using HorizonSideRobots
mutable struct SmartRobot
    robot::Robot
    x::Int
    y::Int
    allowPaint::Bool
    update::Function
    storage::Dict
end
function blank()
    return 0
end
function SmartRobot(robot::Robot) 
    return SmartRobot(robot, 0, 0, true, ()->0, Dict{String, Any}())
end
function SetUpdateFunc(robot, func = ()->0)
    robot.update = func
end
function GetFromStorage(robot, name)
    return robot.storage[name]
end
function SetStorageItem(robot, name, value)
    robot.storage[name] = value 
end
function resetCoords(robot::SmartRobot)
    robot.x = 0
    robot.y = 0
end
function getHomeCoords(moves)
    homeX = 0
    homeY = 0
    for move in moves 
        if move[1] == Nord
            homeY += move[2]
        elseif move[1] == Sud
            homeY -= move[2]
        elseif move[1] == West
            homeX += move[2]
        elseif move[1] == Ost
            homeX -= move[2]
        end
    end
    return (homeX, homeY)
end
function HorizonSideRobots.move!(robot::SmartRobot, side)
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
    robot.update()
end
function HorizonSideRobots.putmarker!(robot::SmartRobot)
    if robot.allowPaint
        putmarker!(robot.robot)
    end
end
function HorizonSideRobots.isborder(robot::SmartRobot, side)
    return isborder(robot.robot, side)
end
function HorizonSideRobots.ismarker(robot::SmartRobot)
    return ismarker(robot.robot)
end
function HorizonSideRobots.sitedit!(robot::SmartRobot, sitfile)
    sitedit!(robot.robot, sitfile)
end
function smartMove(robot::SmartRobot, side, moveUntil, genFunc)#двигается до выполнения функции moveUntil и исполняет genFunc каждый ход
    while !moveUntil(robot, side)
        move!(robot, side)
        genFunc(robot, side)
    end
end