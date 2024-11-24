local amtStr = arg[2]
local amt = turtle.getFuelLimit()

if amtStr then
    amt = tonumber(amtStr)
end

while turtle.getFuelLevel() < amt do
    turtle.suckDown(1)
    turtle.refuel()
    turtle.drop()
end
