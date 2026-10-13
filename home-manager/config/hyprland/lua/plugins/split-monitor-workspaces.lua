-- package.path = package.path..";./?.lua;./?/init.lua"
-- local smw = require("plugins.split-monitor-workspaces")

-- smw.setup({
--     workspace_count = 5,
--     keep_focused = true,
-- })

-- local hs = require("hyprsplit")
hs.config({
    num_workspaces = 5,
    persistent_workspaces = true
})
