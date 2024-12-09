using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")#загружаем уровень из .sit файла
include("RecursiveFuncs.jl")
function symmetry(robot, side)
    steps = rec_move_until_wall!(robot, side)
    rec_move_until_wall!(robot, rotate(side, 2))
    rec_move_steps!(robot, side, steps)
end
symmetry(robot, West)