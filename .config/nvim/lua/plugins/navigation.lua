return {
    {
        "cbochs/grapple.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "m", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },
        },
        config = function()
            local Grapple = require("grapple")
            local Settings = require("grapple.settings")

            local default_settings = Settings:new()

            Grapple.setup({
                icons = true,
                quick_select = "123456789",
                tag_hook = function(window)
                    window:map("n", "a", function()
                        window:close()
                        Grapple.toggle()
                        Grapple.open_tags()
                    end, { desc = "Toggle tag for current file" })

                    default_settings.tag_hook(window)
                end,
            })
        end,
    },
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
