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
        "mbbill/undotree",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, desc = "[U]ndoTree" },
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
