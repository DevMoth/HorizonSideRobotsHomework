using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "task12.sit")#загружаем уровень из .sit файла

function countInLine(robot, side, gap)#функция подсчета стен в линии
    wallCount = 0#кол-во стен
    currentGap = 0#длина текущего пробела
    isWall = false#считаем ли мы сейчас стену
    while !isborder(robot, side)
        if !isborder(robot, Nord)#над нами нет стены => текущий пробел на 1 длиннее
            currentGap+=1
            if currentGap>gap && isWall#текущий пробел больше позволенного и мы считаем стену => стена оборвалась
                wallCount += 1
                isWall = false
            end
        else#есть стена => считаем стену и нет пробела
            isWall = true
            currentGap = 0
        end
        move!(robot, side)
    end
    if isWall# уперлись в перегородку, считая стену => стена оборвалась
        wallCount += 1
    end
    return wallCount
end
function countHorizontalBorders(robot, gap = 0)
    count = 0
    moves = move_to_corner!(robot)
    move!(robot, Sud)

    side = Ost
    while true
        count += countInLine(robot, side, gap)
        if !isborder(robot, Sud)
            move!(robot, Sud)
            side = rotate(side, 2)
        else
            break
        end
    end
    return count
end

task11(robot) = countHorizontalBorders(robot, 0)
task12(robot) = countHorizontalBorders(robot, 1)
println(task11(robot))
task12(robot)