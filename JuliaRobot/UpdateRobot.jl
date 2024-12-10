using HorizonSideRobots
mutable struct UpdateRobot #обертка робота
    robot::Robot#сам робот
    x::Int #координаты робота
    y::Int
    allowPaint::Bool #разрешение красить(если == false, то робот не сможет ставить маркеры)
    update::Function #функция, которая выполняется роботом каждый шаг
end
function UpdateRobot(robot::Robot) #конструктор робота, ставит стандартные значения всему кроме самого робота( ()->0 это пустая функция )
    return UpdateRobot(robot, 0, 0, true, ()->0)
end
function set_update_func!(robot::UpdateRobot, func = ()->0)# устанавливает функцию обновления робота, если не ставить новую функция, то будет поставлена пустая функция
    robot.update = func
end

function HorizonSideRobots.move!(robot::UpdateRobot, side)#обертка move!, обновляет координаты и выполняет функцию обновления
    
    if side == Nord#обновление координат
        robot.y -= 1
    elseif side == Sud
        robot.y += 1
    elseif side == West
        robot.x -= 1
    elseif side == Ost
        robot.x += 1
    end

    move!(robot.robot, side)

    robot.update()#вызов функции обновления
end
function HorizonSideRobots.putmarker!(robot::UpdateRobot)#обертка putmarker!, ставит маркер, только если allowPaint == true
    if robot.allowPaint
        putmarker!(robot.robot)
    end
end
function HorizonSideRobots.isborder(robot::UpdateRobot, side)
    return isborder(robot.robot, side)
end
function HorizonSideRobots.ismarker(robot::UpdateRobot)
    return ismarker(robot.robot)
end