using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "empty.sit")
function task4!(robot)
    cross!(robot, (Nord, Ost))
end
task4!(robot)