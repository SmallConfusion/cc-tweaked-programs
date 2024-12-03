local ui = require("storage.ui")
local Text = require("storage.ui.text")
local Rect = require("storage.ui.rect")
local Screen = require("storage.ui.screen")

local f = {}

f.isIdle = ui.isIdle


local retrieveItems
local listFunc

if pocket then
    local w = require("storage.wireless")
    w.init()

    retrieveItems = w.retrieveItems
    listFunc = w.list
else
    local b = require("storage.backend")
    retrieveItems = b.retrieveItems
    listFunc = b.list
end


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

    local itemNames = {}

    local arrow = Text.new(Rect.new(1, 3, 1, 1), ">")
    local list = Text.new(Rect.new(3, 3, 52, 17))

    -- Arrow
    arrow.selected = 1
    arrow:addKeyCallback(function(key)
        if key == keys.up then
            arrow.selected = math.max(arrow.selected - 1, 1)
        elseif key == keys.down then
            arrow.selected = math.min(arrow.selected + 1, math.min(#itemNames, 17))
        end

        arrow.rect.y = 2 + arrow.selected
    end)

    mainScreen:addPart(arrow)

    -- List

    local blist = listFunc()

    local function listCallback()
        itemNames = {}
        local text = ""

        for itemName, count in pairs(blist) do
            if f.match(itemName, input.contents) then
                itemNames[#itemNames + 1] = itemName
            end
        end

        table.sort(itemNames)

        for _, name in pairs(itemNames) do
            local displayName = name

            if pocket then
                displayName = name:match("([^:]+)$")
            end

            text = text .. displayName .. " " .. blist[name] .. "\n"
        end

        list.contents = text
    end

    list:addCharCallback(listCallback)
    listCallback()

    local itemToGetName = ""
    local select = Screen.new()

    list:addKeyCallback(function(key)
        if key == keys.enter or key == keys.numPadEnter then
            itemToGetName = itemNames[arrow.selected]
            mainScreen.visible = false
            select.visible = true
        end
    end)

    mainScreen:addPart(list)

    ui.addPart(mainScreen)


    -- Item select count
    select.visible = false

    select:addPart(Text.new(Rect.new(1, 1, 52, 1), "Count?"))

    local count = Text.new(Rect.new(1, 2, 52, 1))

    count:addCharCallback(function(char)
        count.contents = count.contents .. char
    end)

    local done = false
    count:addKeyCallback(function(key)
        if key == keys.backspace then
            count.contents = count.contents:sub(1, #count.contents - 1)
        elseif key == keys.enter or key == keys.numPadEnter then
            if not done then
                done = true
                return
            end

            local itemCount

            if count.contents:sub(#count.contents, #count.contents) == "s" then
                itemCount = tonumber(count.contents:sub(1, #count.contents - 1)) * 64 or 64
            else
                itemCount = tonumber(count.contents) or 64
            end

            done = false
            select.visible = false
            mainScreen.visible = true
            retrieveItems(itemToGetName, itemCount)

            count.contents = ""
        end
    end)


    select:addPart(count)

    ui.addPart(select)

    parallel.waitForAny(ui.loop, function()
        while true do
            blist = listFunc()
            os.sleep(0.5)
        end
    end)
end

---@param str string
---@param search string
---@return boolean
function f.match(str, search)
    return str:find(search)
end

return f
