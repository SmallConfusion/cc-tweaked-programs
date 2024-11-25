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
    local y = 0

    while y < self.h and #text > 0 do
        local s, e = text:find("\n")

        if s and e then
            local before = text:sub(1, s - 1)

            term.setCursorPos(self.x, self.y + y)
            term.write(before)

            text = text:sub(e + 1, #text)
        else
            term.setCursorPos(self.x, self.y + y)
            term.write(text)
            return
        end

        y = y + 1
    end
end

return Rect
