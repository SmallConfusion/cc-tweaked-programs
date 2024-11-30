local wg = "wget https://raw.githubusercontent.com/SmallConfusion/cc-tweaked-programs/refs/heads/main/storage/"

--- download file from github
---@param file string
---@param path string
local function dlf(file, path)
    shell.run("rm " .. path)
    shell.run(wg .. file .. " " .. path)
end

dlf("init.lua", "storage/init.lua")
dlf("backend.lua", "storage/backend.lua")
dlf("frontend.lua", "storage/frontend.lua")
dlf("ui/init.lua", "storage/ui/init.lua")
dlf("ui/text.lua", "storage/ui/text.lua")
dlf("ui/rect.lua", "storage/ui/rect.lua")
dlf("ui/screen.lua", "storage/ui/screen.lua")
dlf("startup.lua", "startup.lua")
dlf("full.lua", "full.lua")
