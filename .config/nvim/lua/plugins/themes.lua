return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        enabled = true,
        priority = 1000,
        opts = {
            flavour = "mocha",
            integrations = {
                cmp = true,
                treesitter = true,
                telescope = {
                    enabled = true,
                },
                mini = {
                    enabled = true,
                },
                neogit = true,
            },
        },
    },
    {
        "folke/tokyonight.nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        enabled = false,
        lazy = false,
        priority = 1000,
        opts = {},
    },
}
