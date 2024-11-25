local Screen = {}

---@return table
function Screen.new()
    local t = setmetatable({}, { __index = Screen })

    t.parts = {}
    t.visible = true

    return t
end

function Screen:refresh()
    if not self.visible then
        return
    end

    for _, part in pairs(self.parts) do
        part:refresh()
    end
end

---@param part table
function Screen:addPart(part)
    self.parts[#self.parts + 1] = part
end


function Screen:keyInput(key)
    if not self.visible then
        return
    end

    for _, part in pairs(self.parts) do
        if part.keyInput then
            part:keyInput(key)
        end
    end
end


function Screen:charInput(char)
    if not self.visible then
        return
    end

    for _, part in pairs(self.parts) do
        if part.charInput then
            part:charInput(char)
        end
    end
end

return Screen
