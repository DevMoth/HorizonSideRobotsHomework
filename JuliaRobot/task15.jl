using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
include("SmartRobot.jl")
robot = Robot(animate = true)
sitedit!(robot, "task6.sit")#загружаем уровень из .sit файла
function markOnDiagonal(robot)
    if abs(robot.x) == abs(robot.y) != 0
        putmarker!(robot)
    end
end
function task15!(robot)
    robot = SmartRobot(robot)
    home = move_to_corner!(robot)

    set_update_func!(robot, ()->markOnDiagonal(robot))
    snake_with_nav!(robot, (Ost, Sud))

    return_home!(robot, home)
end
task15!(robot)