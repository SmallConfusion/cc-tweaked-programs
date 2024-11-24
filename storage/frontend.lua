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

    local _, key, _

    while key ~= keys.enter do
        term.write(keys.getName(key))
    end
end


function f.getKey()
    return os.pullEvent("key")
end


function f.cancel()

end

return f
