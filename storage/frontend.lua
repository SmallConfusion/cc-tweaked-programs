local b = require("storage.backend")
local f = {}

function f.run()
    term.clear()

    while true do
        local _, key, _ = f.getKey()

        if key == keys.g then
            f.get()
        end
    end
end

function f.get()
    term.clear()
    term.setCursorPos(1, 1)
    term.write("Get: ")

    local _, key, _ = f.getKey()
    local getName = ""
    local getCount = ""
    local gettingCount = false

    while key ~= keys.enter do
        local keyName = keys.getName(key)

        if #keyName == 1 and not gettingCount then
            term.write(keyName)
            getName = getName .. keyName

        elseif gettingCount then
            local number = key - 48
            local numString = tostring(number)

            term.write(numString)
            getCount = getCount .. numString
        end

        if key == keys.space then
            term.write(" ")
            gettingCount = true
        end

        _, key, _ = f.getKey()
    end

    if #getCount > 0 then
        getCount = tonumber(getCount)
    else
        getCount = 64
    end

    b.retrieveItems(b.matchItemName, getCount)
end

function f.getKey()
    return os.pullEvent("key")
end

function f.cancel()

end

return f
