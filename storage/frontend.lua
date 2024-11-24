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

        if #keyName == 1 then
            os.write(keyName)

            if not gettingCount then
                getName[#getName + 1] = keyName
            else
                getCount[#getCount + 1] = keyName
            end
        end

        if key == keys.space then
            os.write(" ")
            gettingCount = true
        end

        _, key, _ = f.getKey()
    end

    if #getCount > 0 then
        getCount = tonumber(getCount)
    else
        getCount = 64
    end

    b.retrieveItems(b.matchItemName)
end


function f.getKey()
    return os.pullEvent("key")
end


function f.cancel()

end

return f
