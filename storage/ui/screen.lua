local Screen = {}

---@return table
function Screen.new()
    local t = setmetatable({}, { __index = Screen })

    t.parts = {}

    return t
end

function Screen:refresh()
    term.clear()

    for _, part in pairs(self.parts) do
        part:refresh()
    end
end

---@param part table
function Screen:addPart(part)
    self.parts[#self.parts + 1] = part
end


function Screen:keyInput(key)
    for _, part in pairs(self.parts) do
        if part.keyInput then
            part:keyInput(key)
        end
    end
end


function Screen:charInput(char)
    for _, part in pairs(self.parts) do
        if part.charInput then
            part:charInput(char)
        end
    end
end

return Screen
