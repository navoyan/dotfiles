local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("MagicDuck/grug-far.nvim"),
    })

    require("grug-far").setup()

    map({ "n", "v" }, "<Leader>sr", function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
            transient = true,
            prefills = {
                filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
        })
    end)
end)
