sitedit!(robot, "untitled.sit")
function moveUntilWall(robot, side, lay = false)
    counter = 0
    while !isborder(robot, side)
        counter += 1
        if lay
            putmarker!(robot)
        end
        move!(robot, side)
    end
    return counter
end
function layChessStrip(robot, side, lay = false)
    while true
        if lay
            putmarker!(robot)
        end
        lay = !lay
        if isborder(robot, Ost)
            break
        end
        move!(robot, side)
    end
end
yoff = moveUntilWall(robot, Nord)
xoff = moveUntilWall(robot, West)
offset = ((yoff+xoff) % 2 == 0)
while true
    layChessStrip(robot, Ost, offset)
    global offset = !offset
    moveUntilWall(robot, West)
    if isborder(robot, Sud)
        break
    end
    move!(robot, Sud)
end
moveUntilWall(robot, Nord)
moveUntilWall(robot, West)
for _ in 1:yoff
    move!(robot, Sud)
end
for _ in 1:xoff
    move!(robot, Ost)
end