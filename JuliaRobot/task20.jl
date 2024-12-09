using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")#загружаем уровень из .sit файла
function move_with_bounce!(robot, side, steps = 0, bounced = false)
    if isborder(robot, side)#отскок от стены
        putmarker!(robot)
        bounced = true
        side = rotate(side, 2)
    end
    move!(robot, side)
    if !bounced
        steps += 1
    else
        steps -= 1
    end
    if steps == 0 && bounced
        return 0
    end
    move_with_bounce!(robot, side, steps, bounced)
end
move_with_bounce!(robot, Nord)