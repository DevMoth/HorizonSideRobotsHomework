using HorizonSideRobots
include("MainFuncs.jl")
include("SmartRobot.jl")
robot = Robot(animate = true)
sitedit!(robot, "task6.sit")
function task6a!(robot)
    moves = move_to_corner!(robot)

    perimeter!(Paint(robot), Ost)

    return_home!(robot, moves)
end

function is_aligned_to_home(robot)#ставит маркер, если робот находится напротив старта
    if (robot.x == 0) || (robot.y == 0)
        putmarker!(robot)
    end
end
function task6b!(robot)
    robot = SmartRobot(robot)
    moves = move_to_corner!(robot)

    set_update_func!(robot, ()->is_aligned_to_home(robot))
    perimeter!(robot, Ost)

    robot.allowPaint = false

    return_home!(robot, moves)
end
task6b!(robot)