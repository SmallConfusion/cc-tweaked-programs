local b = require("storage.backend")
local ui = require("storage.ui")
local Text = require("storage.ui.text")
local Rect = require("storage.ui.rect")

local f = {}

f.isIdle = ui.isIdle

function f.run()
    local inputTest = Text.new(Rect.new(1, 1, 15, 5), "Type")

    inputTest:addCharCallback(function(char)
        inputTest.contents = inputTest.contents..char
    end)

    ui.addPart(inputTest)

    ui.loop()
end

return f
