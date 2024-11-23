local tm = {}

local dir = {
    NORTH = 1,
    EAST = 2,
    SOUTH = 3,
    WEST = 4
}

tm.pos = vector.new(0, 0, 0)
tm.dir = dir.NORTH

---@param move table
---@return boolean success
function tm.move(move)
    local com

    if move.y == -1 then
        com = turtle.down
    elseif move.y == 1 then
        com = turtle.up
    else
        com = function()
            return tm.trackedRotate(tm.getDirVec(move)) and turtle.forward()
        end
    end

    local success = com()

    if success then
        tm.pos = tm.pos + move
    end

    print("Moved to " .. tm.pos.x .. " " .. tm.pos.y .. " " .. tm.pos.z)

    return success
end

---@param block table
---@return boolean success, boolean has_block, table | string blockinfo
function tm.inspect(block)
    local com

    if block.y == -1 then
        com = turtle.inspectDown
    elseif block.y == 1 then
        com = turtle.inspectUp
    else
        com = function()
            if tm.trackedRotate(tm.getDirVec(block)) then
                return turtle.inspect()
            else
                return false, "Failed to rotate"
            end
        end
    end

    return true, com()
end

---@param block table
---@return boolean success
function tm.dig(block)
    local com

    if block.y == -1 then
        com = turtle.digDown
    elseif block.y == 1 then
        com = turtle.digUp
    else
        com = function()
            local rs = tm.trackedRotate(tm.getDirVec(block))

            if rs then
                return turtle.dig()
            else
                return false, "Failed turn"
            end
        end
    end

    return com()
end

---@param vec table
---@return integer direction
function tm.getDirVec(vec)
    if vec.x == -1 then
        return dir.EAST
    end
    if vec.x == 1 then
        return dir.WEST
    end
    if vec.z == -1 then
        return dir.NORTH
    end
    if vec.z == 1 then
        return dir.SOUTH
    end
    return dir.NORTH
end

---@param amt integer
function tm.loopedRotate(amt)
    tm.dir = ((tm.dir + amt - 1) % 4) + 1
end

---@param to integer
function tm.trackedRotate(to)
    if to < tm.dir then
        to = to + 4
    end

    local turnAmt = to - tm.dir
    if turnAmt > 2 then
        turnAmt = turnAmt - 4
    end

    while turnAmt > 0 do
        local success = turtle.turnRight()

        if success then
            turnAmt = turnAmt - 1
            tm.loopedRotate(1)
        else
            return false
        end
    end

    while turnAmt < 0 do
        local success = turtle.turnLeft()

        if success then
            turnAmt = turnAmt + 1
            tm.loopedRotate(-1)
        else
            return false
        end
    end

    return true
end

return tm
