using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")
function task3!(robot)
    moves = move_to_corner!(robot)

    putmarker!(robot)
    snake!(()->isborder(robot, (Ost, Sud), strict = true), Paint(robot), (Ost, Sud))
    
    return_home!(robot, moves)
end
task3!(robot)