using HorizonSideRobots
include("MainFuncs.jl")
sitedit!(robot, "untitled.sit")
function perimeter(robot)
    moves = MoveToCorner(robot)
    for side in [Ost, Sud, West, Nord]
        moveUntil(()->isborder(robot, side), Paint(robot), side)
    end
    ReturnHome(robot, moves)
end
perimeter(robot)