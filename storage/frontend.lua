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
    local com = f.split(f.getCommand())
    
    local name = com[1]
    local count = tonumber(com[2])

    b.retrieveItems(b.matchItemName(name), count)
end

---@param commandName string
---@return string command
function f.getCommand(commandName)
    term.clear()
    term.setCursorPos(1, 1)
    term.write(commandName)

    local com = ""

    local _, key, _ = f.getKey()

    while key ~= keys.enter do
        local keyName = keys.getName(key)

        if #keyName == 1 then
            com = com .. keyName
        elseif key >= 48 and key <= 57 then
            com = com .. tostring(key - 48)
        elseif key == keys.underscore then
            com = com .. "_"
        elseif key == keys.space then
            com = com .. " "
        elseif key == keys.backspace then
            com = com:sub(1, #com - 1)
        end

        term.clear()
        term.setCursorPos(1, 1)
        term.write(commandName .. com)

        _, key, _ = f.getKey()
    end

    return com
end

function f.getKey()
    return os.pullEvent("key")
end

function f.cancel()

end

---@param s string
---@param delim string
---@return table
function f.split(s, delim)
    if sep == "nil" then
        sep = "%s"
    end

    local t = {}

    for str in s:gmatch("([^"..delim.."]+)") do
        t[#t + 1] = str
    end

    return t
end

return f
