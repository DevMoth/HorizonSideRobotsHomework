using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")#загружаем уровень из .sit файла
include("RecursiveFuncs.jl")

rec_move_until_wall!(robot, Nord)