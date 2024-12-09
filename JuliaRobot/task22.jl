using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")#загружаем уровень из .sit файла
function x2move_with_bounce!(robot, side, steps = 0, bounced = false)
    if isborder(robot, side) && !bounced#отскок
        bounced = true
        side = rotate(side, 2)
        steps *= 2
    end
    if isborder(robot, side) && bounced#уже отскочил и встретил стену => нельзя так пройти
        return false
    end
    if steps == 0 && bounced#дошел до нужной позиции
        return true
    end
    move!(robot, side)
    if !bounced
        steps += 1
    else
        steps -= 1
    end
    x2move_with_bounce!(robot, side, steps, bounced)
end
x2move_with_bounce!(robot, Nord)