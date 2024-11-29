local b = require("storage.backend")
local f = require("storage.frontend")


local function runStore()
    while true do
        ---@diagnostic disable-next-line: undefined-field
        if b.cacheOutdated then
            b.refreshCache()
        end

        b.storeAll()
    end
end

parallel.waitForAny(runStore, f.run)
