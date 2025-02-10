return {
    {
        "mrjones2014/smart-splits.nvim",
        lazy = false,
        config = function()
            local splits = require("smart-splits")

            -- creating vim splits
            vim.keymap.set("n", "<leader>sh", "<cmd>vertical leftabove split<cr>")
            vim.keymap.set("n", "<leader>sj", "<cmd>horizontal belowright split<cr>")
            vim.keymap.set("n", "<leader>sk", "<cmd>horizontal topleft split<cr>")
            vim.keymap.set("n", "<leader>sl", "<cmd>vertical rightbelow split<cr>")
            -- moving between splits
            vim.keymap.set("n", "<A-h>", splits.move_cursor_left)
            vim.keymap.set("n", "<A-j>", splits.move_cursor_down)
            vim.keymap.set("n", "<A-k>", splits.move_cursor_up)
            vim.keymap.set("n", "<A-l>", splits.move_cursor_right)
            -- resizing splits
            vim.keymap.set("n", "<C-Space>r<Left>", splits.resize_left)
            vim.keymap.set("n", "<C-Space>r<Down>", splits.resize_down)
            vim.keymap.set("n", "<C-Space>r<Up>", splits.resize_up)
            vim.keymap.set("n", "<C-Space>r<Right>", splits.resize_right)
        end,
    },
    {
        "christoomey/vim-tmux-navigator",
        enabled = false,
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<M-h>", "<cmd>TmuxNavigateLeft<cr>" },
            { "<M-j>", "<cmd>TmuxNavigateDown<cr>" },
            { "<M-k>", "<cmd>TmuxNavigateUp<cr>" },
            { "<M-l>", "<cmd>TmuxNavigateRight<cr>" },
        },
    },
    {
        "mikesmithgh/kitty-scrollback.nvim",
        enabled = false,
        lazy = true,
        cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
        event = { "User KittyScrollbackLaunch" },
        -- version = '*', -- latest stable version, may have breaking changes if major version changed
        -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
        config = function()
            require("kitty-scrollback").setup()
        end,
    },
}
