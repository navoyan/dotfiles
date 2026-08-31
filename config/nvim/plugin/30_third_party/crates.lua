local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("saecki/crates.nvim"),
    })

    require("crates").setup({
        enable_update_available_warning = false,
        completion = {
            crates = {
                enabled = true,
            },
        },
        lsp = {
            enabled = true,
            actions = true,
            completion = true,
            hover = true,
        },
    })
end)
