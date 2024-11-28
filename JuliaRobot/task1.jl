using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function task1(robot)
    cross(robot, Nord)
end
task1(robot)