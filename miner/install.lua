local wg = "wget https://raw.githubusercontent.com/SmallConfusion/cc-tweaked-programs/refs/heads/main/miner/"

--- download file from github
---@param file string
---@param path string
local function dlf(file, path)
    shell.run("rm " .. path)
    shell.run(wg .. file .. " " .. path)
end

dlf("init.lua", "miner/init.lua")
dlf("tracked_movement.lua", "miner/tracked_movement.lua")
dlf("mine.lua", "mine.lua")
