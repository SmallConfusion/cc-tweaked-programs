local b = require("storage.backend")
local f = require("storage.frontend")


function runStore()
    while true do
        b.storeAll()
        os.sleep(1.0)
    end
end

parallel.waitForAny(runStore, f.run)
