local b = require("storage.backend")
local f = require("storage.frontend")


local function runStore()
    while true do
        b.storeAll()

        ---@diagnostic disable-next-line: undefined-field
        os.sleep(1.0)

        ---@diagnostic disable-next-line: undefined-field
        if b.cacheOutdated and f.lastInput - os.epoch("utc") > 20000 then
            b.refreshCache()
        end
    end
end

parallel.waitForAny(runStore, f.run)
