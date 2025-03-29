return {
    "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
        -- use opts = {} for passing setup options
        -- this is equalent to setup({}) function
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
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            disabled_filetypes = {
                "qf",
                "lazy",
                "help",
                "man",
                "scrollback",
                "grug-far",
                "undotree",
            },
        },
    },
}
