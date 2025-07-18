return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
            on_highlights = function(highlights, colors)
                -- NOTE: fixes `live-rename.nvim` highlighting
                highlights.Normal = { fg = colors.fg, bg = colors.bg }
            end,
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        enabled = false,
        priority = 1000,
        opts = {
            flavour = "mocha",
            integrations = {
                cmp = true,
                treesitter = true,
                mini = {
                    enabled = true,
                },
                neogit = true,
            },
        },
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        enabled = false,
        lazy = true,
        priority = 1000,
        opts = {},
    },
}
