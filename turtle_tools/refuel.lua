local amt = args[2]

if amt then
    amt = tonumber(amt)
else
    amt = turtle.getFuelLimit()
end

while turtle.getFuelLevel() < amt do
    turtle.suckDown(1)
    turtle.refuel()
    turtle.drop()
end
