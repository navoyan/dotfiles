local schedule, config = require("schedule"), require("config")

schedule.now(function()
    vim.pack.add({
        config.github("MunifTanjim/nui.nvim"),
        config.github("folke/noice.nvim"),
    })

    require("noice").setup({
        -- add any options here
        lsp = {
            progress = {
                enabled = false,
            },
        },
        views = {
            mini = {
                reverse = false,
                timeout = 5000,
            },
            cmdline_popup = {
                border = {
                    style = "single",
                },
            },
        },
    })
end)
