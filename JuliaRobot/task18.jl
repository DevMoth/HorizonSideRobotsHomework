using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "task18.sit")#загружаем уровень из .sit файла
function task18!(robot)
    spiral_with_nav!(()->ismarker(robot), robot)
end
task18!(robot)