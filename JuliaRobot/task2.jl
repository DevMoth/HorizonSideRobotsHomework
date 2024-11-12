using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function perimeter(robot)
    moves = MoveToCorner(robot)
    perimeter(Paint(robot), Ost)
    ReturnHome(robot, moves)
end
perimeter(robot)