using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")
function task2!(robot)
    moves = move_to_corner!(robot)

    perimeter!(Paint(robot), Ost)
    
    return_home!(robot, moves)
end
task2!(robot)