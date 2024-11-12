using HorizonSideRobots
include("MainFuncs.jl")
include("SmartRobot.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function chessMark(robot::SmartRobot)
    if (robot.x+robot.y) % 2 == 0
        putmarker!(robot)
    end
end
function task9(robot)
    robot = SmartRobot(robot)
    SetUpdateFunc(robot, ()->chessMark(robot))
    moves = MoveToCorner(robot)
    snakeWithNav(robot, (Ost, Sud))
    ReturnHome(robot, moves)
end
task9(robot)