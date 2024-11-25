local Rect = {}


---@param x integer?
---@param y integer?
---@param w integer?
---@param h integer?
---@return table
function Rect.new(x, y, w, h)
    local t = setmetatable({}, { __index = Rect })

    t.x = (x or 1)
    t.y = (y or 1)
    t.w = (w or 10)
    t.h = (h or 1)

    return t
end

function Rect:writeText(text)
    for i = 1, #text do
        local char = text:sub(i, i)

        local i0 = i - 1

        local x = self.x + i0 % self.w
        local localY = math.floor(i0 / self.w)

        if localY >= self.h then
            return
        end

        local y = self.y + localY

        term.setCursorPos(x, y)
        term.write(char)
    end
end

return Rect
