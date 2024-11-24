local s = {}

s.inChest = {}
s.outChest = {}
s.heap = {}

function s.init()
    settings.define("storage.input", {
        default = "input_name"
    })
    settings.define("storage.output", {
        default = "output_name"
    })

    if not settings.get("storage.input") then
        print("set settings")
        settings.save()
        exit()
    end

    s.registerChests()
end

function s.registerChests()
    s.inChest = peripheral.wrap(settings.get("storage.input"))
    s.outChest = peripheral.wrap(settings.get("storage.output"))

    s.heap = {peripheral.find("inventory", function(name, chest)
        return name ~= peripheral.getName(s.inChest) and name ~= peripheral.getName(s.outChest)
    end)}
end

function s.storeItems(fromSlot, from)
    if from == nil then
        from = s.inChest
    end

    local item = s.safeCall(from.getItemDetail, fromSlot)

    local leftCount = item.count

    for _, chest in pairs(s.heap) do
        local toName = peripheral.getName(chest)
        local transferred = s.safeCall(from.pushItems, toName, fromSlot)

        leftCount = leftCount - transferred

        if leftCount <= 0 then
            return
        end
    end
end

---@param itemMatch function
---@param count integer
---@return integer done
function s.retrieveItems(itemMatch, count)
    local total = 0

    for _, chest in pairs(s.heap) do
        for i, item in pairs(chest.list()) do
            if itemMatch(item) then
                local toName = peripheral.getName(s.outChest)
                local all_transferred = false
                local ic = item.count

                while not all_transferred do
                    local transferred = s.safeCall(chest.pushItems, toName, i, count)
                    total = total + transferred
                    count = count - transferred
                    ic = ic - transferred

                    if count <= 0 then
                        return total
                    end

                    all_transferred = ic == 0

                    if not all_transferred then
                        os.sleep(0.5)
                    end
                end
            end
        end
    end

    return total
end

function s.list()
    local t = {}

    for _, chest in pairs(s.heap) do
        for _, item in pairs(s.safeCall(chest.list)) do
            if not t[item.name] then
                t[item.name] = 0
            end
            t[item.name] = t[item.name] + item.count
        end
    end

    return t
end

function s.getTotalSize()
    local size = 0

    for _, chest in pairs(s.heap) do
        size = size + s.safeCall(chest.size)
    end

    return size
end

function s.getUsedSize()
    local used = 0

    for _, chest in pairs(s.heap) do
        used = used + #s.safeCall(chest.list)
    end

    return used
end

function s.defragment()
    for i = #s.heap, 1, -1 do
        local chest = s.heap[i]

        for i, item in pairs(s.safeCall(chest.list)) do
            if item then
                s.storeItems(i, chest)
            end
        end
    end
end

function s.storeAll()
    for i, _ in pairs(s.safeCall(s.inChest.list)) do
        s.storeItems(i)
    end
end

function s.matchItemName(name)
    return function(item)
        return item.name == name
    end
end

function s.safeCall(call, a, b, c, d, e, f)
    local result = nil
    local success = false

    while not result or not success do
        success, result = pcall(call, a, b, c, d, e, f)
    end

    return result
end

s.init()

return s