local b = require("storage.backend")
local f = {}

function f.run()
    term.clear()

    while true do
        local _, key, _ = f.getKey()

        term.clear()
        term.setCursorPos(1, 1)
        term.print("Enter a key to start. Press g to get, press s to search.")

        if key == keys.g then
            f.get()
        elseif key == keys.s then
            f.search()
        end
    end
end

function f.get()
    local com = f.split(f.getCommand("Get: "))

    local name = com[1]

    local count = 64

    if com[2] then
        count = tonumber(com[2])
    end

    local got = b.retrieveItems(b.matchItemName(name), count)

    term.setCursorPos(1, 2)
    term.write(got.." items got")
end

function f.search()
    local list, com

    parallel.waitForAll(
        function() list = b.list() end,
        function() com = f.getCommand("Search: ") end
    )

    term.setCursorPos(1, 2)

    for name, count in pairs(list) do
        if item:find(com) then
            print(name.." "..count)
        end
    end
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
        elseif key == keys.minus or key == keys.underscore then
            com = com .. "_"
        elseif key == keys.space then
            com = com .. " "
        elseif key == keys.color or key == keys.semiColon then
            com = com .. ":"
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
    if not delim then
        delim = "%s"
    end

    local t = {}

    for str in s:gmatch("([^" .. delim .. "]+)") do
        t[#t + 1] = str
    end

    return t
end

return f
