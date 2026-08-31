local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("j-hui/fidget.nvim"),
    })

    require("fidget").setup({
        notification = {
            window = {
                winblend = 0, -- Background color opacity in the notification window
            },
        },
    })
end)
