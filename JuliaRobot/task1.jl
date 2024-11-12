using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function cross(robot)
    for side in [Ost, Sud, West, Nord]
        steps = moveUntil(()->isborder(robot, side), Paint(robot), side)
        moveSteps(robot, rotate(side, 2), steps)
    end
end
cross(robot)