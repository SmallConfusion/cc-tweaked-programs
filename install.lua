local wg = "wget https://raw.githubusercontent.com/SmallConfusion/cct-miner/refs/heads/main/"

--- download file from github
---@param file string
---@param path string
local function dlf(file, path)
    shell.run(wg + file + " " + path)
end

dlf("init.lua", "miner/init.lua")
dlf("tracked_movement.lua", "miner/tracked_movement.lua")
