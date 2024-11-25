local b = require("storage.backend")
local ui = require("storage.ui")
local Text = require("storage.ui.text")
local Rect = require("storage.ui.rect")
local Screen = require("storage.ui.screen")

local f = {}

f.isIdle = ui.isIdle

function f.run()
    local mainScreen = Screen.new()

    local input = Text.new(Rect.new(1, 1, 52, 5), "")

    input:addCharCallback(function(char)
        input.contents = input.contents .. char
    end)

    input:addKeyCallback(function(key)
        if key == keys.backspace then
            input.contents = input.contents:sub(1, #input.contents - 1)
        end
    end)

    mainScreen:addPart(input)

    local list = Text.new(Rect.new(3, 3, 52, 17))

    list:addCharCallback(function(char)
        local text = ""

        for itemName, count in pairs(b.list()) do
            if f.match(itemName, input.contents) then
                text = text .. itemName .. " " .. count .. "\n"
            end
        end

        list.contents = text
    end)

    mainScreen:addPart(list)

    ui.addPart(mainScreen)

    ui.loop()
end

---@param str string
---@param search string
---@return boolean
function f.match(str, search)
    return str:find(search)
end

return f
