using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
include("SmartRobot.jl")
include("RecursiveFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "labyrinth.sit")#загружаем уровень из .sit файла
function task26(robot)
    robot = SmartRobot(robot)
    SetUpdateFunc(robot, ()->putmarker!(robot))
    walkLabyrinth(LabBot(robot))
end
task26(robot)