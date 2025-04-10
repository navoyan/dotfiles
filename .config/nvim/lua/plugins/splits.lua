return {
    {
        "mrjones2014/smart-splits.nvim",
        lazy = false,
        build = "./kitty/install-kittens.bash",
        config = function()
            local splits = require("smart-splits")

            -- creating vim splits
            vim.keymap.set("n", "<leader>sh", "<cmd>vertical leftabove split<cr>")
            vim.keymap.set("n", "<leader>sj", "<cmd>horizontal belowright split<cr>")
            vim.keymap.set("n", "<leader>sk", "<cmd>horizontal topleft split<cr>")
            vim.keymap.set("n", "<leader>sl", "<cmd>vertical rightbelow split<cr>")
            -- moving between splits
            vim.keymap.set("n", "<M-h>", splits.move_cursor_left)
            vim.keymap.set("n", "<M-j>", splits.move_cursor_down)
            vim.keymap.set("n", "<M-k>", splits.move_cursor_up)
            vim.keymap.set("n", "<M-l>", splits.move_cursor_right)
            -- resizing splits
            vim.keymap.set("n", "<M-S-h>", splits.resize_left)
            vim.keymap.set("n", "<M-S-j>", splits.resize_down)
            vim.keymap.set("n", "<M-S-k>", splits.resize_up)
            vim.keymap.set("n", "<M-S-l>", splits.resize_right)
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
}
