local b = require("storage.backend")
local f = require("storage.frontend")


local function runStore()
    while true do
        ---@diagnostic disable-next-line: undefined-field
        if b.cacheOutdated and f.isIdle() then
            b.refreshCache()
        end

        b.storeAll()

        ---@diagnostic disable-next-line: undefined-field
        os.sleep(1.0)
    end
end

parallel.waitForAny(runStore, f.run)
