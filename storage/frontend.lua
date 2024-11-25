local b = require("storage.backend")
local ui = require("storage.ui")
local Text = require("storage.ui.text")
local Rect = require("storage.ui.rect")
local Screen = require("storage.ui.screen")

local f = {}

f.isIdle = ui.isIdle

function f.run()
    local mainScreen = Screen.new()

    -- Input
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

    -- Arrow
    local arrow = Text.new(Rect.new(1, 3, 1, 1), ">")

    arrow.selected = 1
    arrow:addKeyCallback(function(key)
        if key == keys.up then
            arrow.selected = math.max(arrow.selected - 1, 1)
        elseif key == keys.down then
            arrow.selected = math.min(arrow.selected + 1, 17)
        end

        arrow.rect.y = 2 + arrow.selected
    end)

    mainScreen:addPart(arrow)

    -- List
    local list = Text.new(Rect.new(3, 3, 52, 17))

    local itemNames = {}

    local function listCallback()
        itemNames = {}
        local text = ""

        for itemName, count in pairs(b.list()) do
            if f.match(itemName, input.contents) then
                text = text .. itemName .. " " .. count .. "\n"
                itemNames[#itemNames + 1] = itemName
            end
        end

        list.contents = text
    end

    list:addCharCallback(listCallback)
    listCallback()

    list:addKeyCallback(function(key)
        if key == keys.enter or key == keys.numPadEnter then
            f.getItems(itemNames[arrow.selected])
        end
    end)

    mainScreen:addPart(list)

    ui.addPart(mainScreen)
    ui.loop()
end

---@param itemName string
function f.getItems(itemName)
    b.retrieveItems(function(item) return item.name == itemName end, 55)
end

---@param str string
---@param search string
---@return boolean
function f.match(str, search)
    return str:find(search)
end

return f
