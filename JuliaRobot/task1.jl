using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")
function task1!(robot)
    cross!(robot, Nord)
end
task1!(robot)