using HorizonSideRobots
include("MainFuncs.jl")
include("UpdateRobot.jl")
robot = Robot(animate = true)
sitedit!(robot, "task6.sit")
function chess_mark(robot::UpdateRobot)
    if (robot.x+robot.y) % 2 == 0
        putmarker!(robot)
    end
end
function task14!(robot)
    robot = UpdateRobot(robot)
    moves = move_to_corner!(robot)

    set_update_func!(robot, ()->chess_mark(robot))
    snake_with_nav!(robot, (Ost, Sud))

    return_home!(robot, moves)
end
task14!(robot)