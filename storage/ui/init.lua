local Screen = require("storage.ui.screen")

local ui = {}

ui.screen = Screen.new()
ui.lastInput = 0
ui.timeout = 30000

function ui.loop()
    ui.refresh()

    while true do
        ---@diagnostic disable-next-line: undefined-field
        local _, key, _ = os.pullEvent("key")

        local character = ""

        parallel.waitForAny(
        ---@diagnostic disable-next-line: undefined-field
            function() _, character = os.pullEvent("char") end,

            ---@diagnostic disable-next-line: undefined-field
            function() os.sleep(0.05) end
        )

        ui.screen:keyInput(key)

        if character then
            ui.screen:charInput(character)
        end

        term.clear()
        ui.screen:refresh()

        ---@diagnostic disable-next-line: undefined-field
        ui.lastInput = os.epoch("utc")
    end
end

function ui.addPart(part)
    ui.screen:addPart(part)
end

function ui.refresh()
    term.clear()
    ui.screen:refresh()
end

---@return boolean
function ui.isIdle()
    ---@diagnostic disable-next-line: undefined-field
    return os.epoch("utc") - ui.lastInput > ui.timeout
end

return ui
