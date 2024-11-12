using HorizonSideRobots
include("MainFuncs.jl")
include("SmartRobot.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function DrawDiagonal(robot, sides)
    counter = 0
    while !isborder(robot, sides)
        move!(robot, sides)
        putmarker!(robot)
        counter += 1
    end
    return counter
end
function task4(robot)
    for side in [Ost, Nord, West, Sud]
        n = DrawDiagonal(robot, (side, side+1))
        moveSteps(robot, (side+2, side+3), n)
    end
end
task4(robot)