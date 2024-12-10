using HorizonSideRobots
include("MainFuncs.jl")
include("UpdateRobot.jl")
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")
function chess_mark(robot::UpdateRobot)
    if (robot.x+robot.y) % 2 == 0
        putmarker!(robot)
    end
end
function task9!(robot)
    robot = UpdateRobot(robot)
    moves = move_to_corner!(robot)

    set_update_func!(robot, ()->chess_mark(robot))
    snake!(()->isborder(robot, (Ost, Sud), strict = true), robot, (Ost, Sud))

    return_home!(robot, moves)
end
task9!(robot)