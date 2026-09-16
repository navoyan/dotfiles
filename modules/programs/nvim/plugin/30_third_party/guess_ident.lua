local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("NMAC427/guess-indent.nvim"),
    })

    require("guess-indent").setup({})
end)
