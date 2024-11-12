using HorizonSideRobots
include("MainFuncs.jl")
include("SmartRobot.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function task4(robot)
    for side in [Ost, Nord, West, Sud]
        n = moveUntil(()->isborder(robot, (side, side+1)), Paint(robot), (side, side+1))
        moveSteps(robot, (side+2, side+3), n)
    end
end
task4(robot)