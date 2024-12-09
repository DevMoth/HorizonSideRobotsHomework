using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")#загружаем уровень из .sit файла
function rec_chessA(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        rec_chessB(robot, side)
    end
end
function rec_chessB(robot, side)
    putmarker!(robot)
    if !isborder(robot, side)
        move!(robot, side)
        rec_chessA(robot, side)
    end
end
rec_chessA(robot, Nord)