local Screen = require("storage.ui.screen")

local ui = {}

ui.screen = Screen.new()
ui.lastInput = 0
ui.timeout = 30000

function ui.loop()
    ui.screen:refresh()

    while true do
        ---@diagnostic disable-next-line: undefined-field
        local _, key, _ = os.pullEvent("key")

        ---@diagnostic disable-next-line: undefined-field
        local _, character = os.pullEvent("char")

        ui.screen:keyInput(key)
        ui.screen:charInput(character)

        ui.screen:refresh()

        ---@diagnostic disable-next-line: undefined-field
        ui.lastInput = os.epoch("utc")
    end
end

function ui.addPart(part)
    ui.screen:addPart(part)
end

---@return boolean
function ui.isIdle()
    ---@diagnostic disable-next-line: undefined-field
    return os.epoch("utc") - ui.timeout > ui.timeout
end

return ui
