using HorizonSideRobots
include("MainFuncs.jl")
include("SmartRobot.jl")
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")
function chess_mark(robot::SmartRobot)
    if (robot.x+robot.y) % 2 == 0
        putmarker!(robot)
    end
end
function task9!(robot)
    robot = SmartRobot(robot)
    moves = move_to_corner!(robot)

    set_update_func!(robot, ()->chess_mark(robot))
    snake!(()->isborder(robot, (Ost, Sud), strict = true), robot, (Ost, Sud))

    return_home!(robot, moves)
end
task9!(robot)