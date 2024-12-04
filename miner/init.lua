local t = require("miner.tracked_movement")

local miner = {}

miner.size_z = 80
miner.size_x = 80

function miner.mine()
    for i = 1, math.floor(miner.size_x / 10) do
        for z = 1, miner.size_z do
            miner.tunnel(vector.new(0, 0, -1))
        end

        for x = 1, 4 do
            miner.tunnel(vector.new(-1, 0, 0))
        end

        for z = 1, miner.size_z do
            miner.tunnel(vector.new(0, 0, 1))
        end

        for x = 1, 4 do
            miner.tunnel(vector.new(-1, 0, 0))
        end
    end

    miner.home()
end

---@param dir table
function miner.tunnel(dir)
    miner.digMove(dir)

    miner.doReturnTrip()

    ---@diagnostic disable-next-line: param-type-mismatch
    miner.runWithAllDirs(miner.mineVein, -dir)
end

---@param dir table
function miner.mineVein(dir)
    local success, hasBlock, block = t.inspect(dir)

    if not success then print(block) end

    ---@diagnostic disable-next-line: param-type-mismatch
    if miner.blockMatch(block) then
        miner.digMove(dir)

        miner.doReturnTrip()

        ---@diagnostic disable-next-line: param-type-mismatch
        miner.runWithAllDirs(miner.mineVein, -dir)

        ---@diagnostic disable-next-line: param-type-mismatch
        t.move(-dir)
    end
end

function miner.doReturnTrip()
    if miner.isInventoryFull() then
        miner.dropItems()
    end

    if turtle.getFuelLevel() < 400 then
        miner.home()
    end
end

function miner.home()
    while t.pos.y < 0 do
        miner.digMove(vector.new(0, 1, 0))
    end

    while t.pos.y > 0 do
        miner.digMove(vector.new(0, -1, 0))
    end

    while t.pos.x < 0 do
        miner.digMove(vector.new(1, 0, 0))
    end

    while t.pos.x > 0 do
        miner.digMove(vector.new(-1, 0, 0))
    end

    while t.pos.z < 0 do
        miner.digMove(vector.new(0, 0, 1))
    end

    while t.pos.z > 0 do
        miner.digMove(vector.new(0, 0, -1))
    end

    exit()
end

---@param fn function
---@param ndir table
function miner.runWithAllDirs(fn, ndir)
    local function runWith(dir)
        -- if ndir ~= dir then
        fn(dir)
        -- end
    end

    runWith(vector.new(0, 1, 0))
    runWith(vector.new(0, -1, 0))

    runWith(vector.new(0, 0, -1))
    runWith(vector.new(-1, 0, 0))
    runWith(vector.new(0, 0, 1))
    runWith(vector.new(1, 0, 0))
end

---@param block table | nil
---@return boolean | nil
function miner.blockMatch(block)
    return block and block.name and (
        (block.name:find("_ore") and not block.name:find("iron") and not block.name:find("redstone")) or
        block.name:find("copper") or
        block.name:find("diamond") or
        block.name:find("coal") or
        -- block.name:find("redstone") or
        -- block.name:find("iron") or
        block.name:find("gold") or
        block.name:find("runic_") or
        block.name:find("acient_debris") or
        block.name:find("raw_%w+_block")
    )
end

---@return boolean
function miner.isInventoryFull()
    return turtle.getItemCount(16) ~= 0
end

function miner.dropItems()
    local pos = t.pos


    while t.pos.y < 0 do
        miner.digMove(vector.new(0, 1, 0))
    end

    while t.pos.y > 0 do
        miner.digMove(vector.new(0, -1, 0))
    end

    while t.pos.x < 0 do
        miner.digMove(vector.new(1, 0, 0))
    end

    while t.pos.x > 0 do
        miner.digMove(vector.new(-1, 0, 0))
    end

    while t.pos.z < 0 do
        miner.digMove(vector.new(0, 0, 1))
    end

    while t.pos.z > 0 do
        miner.digMove(vector.new(0, 0, -1))
    end


    while turtle.getItemCount(1) ~= 0 do
        for i = 16, 1, -1 do
            turtle.select(i)
            turtle.dropDown()
        end

        miner.digMove(vector.new(0, 0, 1))
    end


    while t.pos.z < pos.z do
        miner.digMove(vector.new(0, 0, 1))
    end

    while t.pos.z > pos.z do
        miner.digMove(vector.new(0, 0, -1))
    end

    while t.pos.x < pos.x do
        miner.digMove(vector.new(1, 0, 0))
    end

    while t.pos.x > pos.x do
        miner.digMove(vector.new(-1, 0, 0))
    end

    while t.pos.y < pos.y do
        miner.digMove(vector.new(0, 1, 0))
    end

    while t.pos.y > pos.y do
        miner.digMove(vector.new(0, -1, 0))
    end
end

---@param dir table
function miner.digMove(dir)
    local _, has_block, block = t.inspect(dir)

    repeat
        t.dig(dir)
        _, has_block, block = t.inspect(dir)
    until not has_block or block.tags["minecraft:replaceable"]

    t.move(dir)
end

return miner
