using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "task5.sit")

function draw_outer_perimeter!(robot)#рисует периметр вокруг внутренней перегородки
    for side in [Ost, Sud, West, Nord, Ost]
        move_until!(()->!isborder(robot, side-1), Paint(robot), side)
        move!(Paint(robot), side-1)
    end
end
function task5!(robot)
    moves = move_to_corner!(robot)

    perimeter!(Paint(robot), Ost)#внешний периметр

    height = move_until!(()->isborder(robot, Sud), robot, Sud)#считаем высоту поля
    move_until!(()->isborder(robot, Nord), robot, Nord)

    while !isborder(robot, Ost)#сканируем поле
        move!(robot, Ost)
        length = move_until!(()->isborder(robot, Sud), robot, Sud)#считаем высоту на текущей линии
        if length != height#высота отличается, значет мы нашли внутреннею перегородку
            draw_outer_perimeter!(robot)
            break
        end
        move_until!(()->isborder(robot, Nord), robot, Nord)#возвращаемся наверх
    end

    return_home!(robot, moves)
end

task5!(robot)