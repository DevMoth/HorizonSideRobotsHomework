using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")
function DrawSquare(robot, size)
    counter = 0
    for i in 1:size
        putmarker!(robot)
        move_steps!(robot, West, move_steps!(Paint(robot), Ost, size-1))
        if i < size && !isborder(robot, Nord)
            move!(robot, Nord)
            counter += 1
        end
    end
    move_steps!(robot, Sud, counter)
end
function task10(robot, n, flag = true)
    moves = move_to_corner!(robot, (Sud, West))

    counter = 0
    while true
        if flag#рисовка квадратов 
            DrawSquare(robot, n)
        end
        flag = !flag

        if move_steps!(robot, Ost, n) != n#не смогли пройти n шагов влево => мы у стены
            move_until!(()->isborder(robot, West), robot, West)

            if move_steps!(robot, Nord, n) != n#не смогли пройти n шагов вверх => мы дошли до конца
                break
            end

            counter += 1# переходим на следующий ряд и устанавливаем четность ряда квадратов
            flag = counter%2 == 0
        end
    end

    return_home!(robot, moves, (Sud, West))
end
task10(robot, 5)