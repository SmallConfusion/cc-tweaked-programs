local f = require("storage.frontend")


local function runStore()
    local b = require("storage.backend")

    while true do
        ---@diagnostic disable-next-line: undefined-field
        b.storeAll()
    end
end

local function runRefresh()
    local b = require("storage.backend")
    while true do
        if b.cacheOutdated then
            b.refreshCache()
        else
            os.sleep(0.5)
        end
    end
end


if pocket then
    f.run()
else
    local b = require("storage.backend")
    parallel.waitForAll(runStore, runRefresh, f.run, b.runWireless)
end
