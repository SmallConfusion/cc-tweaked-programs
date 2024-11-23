local wg = "wget https://raw.githubusercontent.com/SmallConfusion/cct-miner/refs/heads/main/storage"

--- download file from github
---@param file string
---@param path string
local function dlf(file, path)
    shell.run("rm " .. path)
    shell.run(wg .. file .. " " .. path)
end

dlf("init.lua", "storage/init.lua")
dlf("backend.lua", "storage/backend.lua")
