local Rect = require("storage.ui.rect")

local Text = {}

---@param rect table?
---@param contents string?
---@return table
function Text.new(rect, contents)
    local t = setmetatable({}, { __index = Text })

    t.rect = (rect or Rect.new())
    t.contents = (contents or "")
    t.charCallbacks = {}
    t.keyCallbacks = {}

    return t
end

function Text:refresh()
    self.rect:writeText(self.contents)
end

---@param callback function
function Text:addKeyCallback(callback)
    self.keyCallbacks[#self.keyCallbacks + 1] = callback
end

---@param callback function
function Text:addCharCallback(callback)
    self.charCallbacks[#self.charCallbacks + 1] = callback
end

---@param key integer
function Text:keyInput(key)
    for _, callback in pairs(self.keyCallbacks) do
        callback(key, self)
    end
end

---@param char string
function Text:charInput(char)
    for _, callback in pairs(self.charCallbacks) do
        callback(char, self)
    end
end

return Text
