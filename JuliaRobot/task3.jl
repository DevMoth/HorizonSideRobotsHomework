using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function task3(robot)
    moves = MoveToCorner(robot)
    putmarker!(robot)
    snake!(()->isborder(robot, (Ost, Sud), strict = true), Paint(robot), (Ost, Sud))
    ReturnHome(robot, moves)
end
task3(robot)