local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("nvim-mini/mini.cmdline"),
    })

    require("mini.cmdline").setup()
end)
