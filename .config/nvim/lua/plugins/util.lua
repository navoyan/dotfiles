return {
    {
        "folke/snacks.nvim",
        version = "*",
        lazy = false,
        priority = 1000,
        opts = {
            bigfile = {},
            quickfile = {},
        },
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        keys = {
            { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>" },
            { "<leader>ot", "<cmd>ObsidianToday<cr>" },
            { "<leader>od", "<cmd>ObsidianDailies<cr>" },
            { "<leader>ow", "<cmd>ObsidianWorkspace<cr>" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "work",
                    path = "~/vaults/work",
                },
                {
                    name = "personal",
                    path = "~/vaults/personal",
                },
            },
        },
    },
}
