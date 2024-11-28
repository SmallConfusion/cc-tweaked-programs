local s = {}

s.inChests = {}
s.outChest = ""

s.heap = {}
s.cache = {}

s.cacheOutdated = true

--- Initializes the system. Called on require()
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
    s.refreshCache()
end

--- Sets the chest names and fills the heap with the chests
function s.registerChests()
    local inChests = settings.get("storage.input")

    for chest in inChests:gmatch("[^%s]*") do
        s.inChests[#s.inChests + 1] = chest
    end

    s.outChest = settings.get("storage.output")

    s.heap = { peripheral.find("inventory", function(name, chest)
        return not s.hasValue(s.inChests, name) and name ~= s.outChest
    end) }
end

function s.hasValue(arr, value)
    for _, v in pairs(arr) do
        if value == v then
            return true
        end
    end

    return false
end

--- Refreshes the cache
function s.refreshCache()
    s.cacheOutdated = false

    local t = {}
    for _, chest in pairs(s.heap) do
        t[peripheral.getName(chest)] = s.safeCall(chest.list)
    end
    s.cache = t
end

--- Calls and it cannot fail
---@param call function
function s.safeCall(call, a, b, c, d, e, f)
    local result = nil
    local success = false

    while not result or not success do
        success, result = pcall(call, a, b, c, d, e, f)
    end

    return result
end

--- Stores items
---@param fromSlot integer
---@param fromName string | nil
function s.storeItems(fromSlot, fromName)
    s.cacheOutdated = true

    local storeItem = s.safeCall(peripheral.call, fromName, "getItemDetail", fromSlot)
    local remainingToStore = storeItem.count

    for chest, items in pairs(s.cache) do
        if s.chestHasSpaceFor(chest, storeItem) then
            local tfCount = s.safeCall(peripheral.call, fromName, "pushItems", chest, fromSlot)
            remainingToStore = remainingToStore - tfCount

            if remainingToStore <= 0 then
                return
            end
        end
    end
end

--- Retrieves items
---@param matchFunc function
---@param count integer
---@return integer gotcount
function s.retrieveItems(matchFunc, count)
    s.cacheOutdated = true
    local remainingToGet = count

    for chest, items in pairs(s.cache) do
        for slot, item in pairs(items) do
            if matchFunc(item) then
                local tfCount = s.safeCall(peripheral.call, chest, "pushItems", s.outChest, slot, remainingToGet)
                remainingToGet = remainingToGet - tfCount

                if remainingToGet <= 0 then
                    goto ret
                end
            end
        end
    end

    ::ret::
    return count - remainingToGet
end

--- Checks if this chest has space for this item
---@param chestName string
---@param checkItem table
function s.chestHasSpaceFor(chestName, checkItem)
    local list = s.cache[chestName]

    -- HACK: Assumes all chests attached are double chests
    if #list < 54 then
        return true
    end

    for i, cacheItem in pairs(list) do
        if checkItem.name == cacheItem.name and checkItem.count < checkItem.maxCount then
            return true
        end
    end

    return false
end

---@return table
function s.list()
    local t = {}

    for chest, items in pairs(s.cache) do
        for i, item in pairs(items) do
            if not t[item.name] then
                t[item.name] = 0
            end

            t[item.name] = t[item.name] + item.count
        end
    end

    return t
end

--- Stores everything in the input chest
function s.storeAll()
    for _, chest in pairs(s.inChests) do
        for i, _ in pairs(s.safeCall(peripheral.call, chest, "list")) do
            s.storeItems(i, chest)
        end
    end
end

s.init()

return s
