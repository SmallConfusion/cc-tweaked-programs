local wg = "wget https://raw.githubusercontent.com/SmallConfusion/cc-tweaked-programs/refs/heads/main/turtle_tools/"

--- download file from github
---@param file string
---@param path string
local function dlf(file, path)
    shell.run("rm " .. path)
    shell.run(wg .. file .. " " .. path)
end

dlf("refuel.lua", "refuel.lua")
