sitedit!(robot, "untitled.sit")
function moveUntilWall(robot, side, lay = false)
    counter = 0
    while !isborder(robot, side)
        counter += 1
        move!(robot, side)
        if lay
            putmarker!(robot)
        end
    end
    return counter
end
yoff = moveUntilWall(robot, Nord)
xoff = moveUntilWall(robot, West)
for side in [Ost, Sud, West, Nord]
    moveUntilWall(robot, side, true)
end
for _ in 1:yoff
    move!(robot, Sud)
end
for _ in 1:xoff
    move!(robot, Ost)
end