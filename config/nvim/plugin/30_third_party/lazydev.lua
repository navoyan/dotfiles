local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("folke/lazydev.nvim"),
    })

    require("lazydev").setup({
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },

            { path = "snacks.nvim", words = { "Snacks" } },
            { path = "mini.bracketed", words = { "MiniBracketed" } },
            { path = "mini.files", words = { "MiniFiles" } },
        },
    })
end)
