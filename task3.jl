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
yoff = moveUntilWall(robot, Nord)
xoff = moveUntilWall(robot, West)
while !isborder(robot, Sud)
    moveUntilWall(robot, Ost, true)
    moveUntilWall(robot, West, true)
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