local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("Wansmer/treesj"),
    })

    local treesj = require("treesj")

    map("n", "J", treesj.toggle)
    map("n", "<Leader>J", function()
        treesj.toggle({ split = { recursive = true } })
    end)
end)
