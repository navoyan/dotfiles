return {
    {
        "ggandor/leap.nvim",
        lazy = false,
        opts = {},
        config = function(_, opts)
            require("leap").setup(opts)
            local map = vim.keymap.set

            map({ "n", "x", "o" }, "<Bs>", "<Plug>(leap)")

            map({ "n", "x", "o" }, "R", function()
                require("leap.treesitter").select({
                    -- To increase/decrease the selection in a clever-f-like manner,
                    -- with the trigger key itself (vRRRRrr...).
                    -- The default keys (<enter>/<backspace>) also work
                    opts = require("leap.user").with_traversal_keys("R", "r"),
                })
            end)

            local leap_remote = require("leap.remote")

            map({ "x", "o" }, "<Enter>", leap_remote.action)

            -- Default <Enter> behaviour for these buftypes
            local excluded_bt = {
                "quickfix",
                "nofile",
                "help",
                "prompt",
                "terminal",
            }

            local enter = vim.api.nvim_replace_termcodes("<Enter>", true, true, true)
            map("n", "<Enter>", function()
                if vim.tbl_contains(excluded_bt, vim.bo.buftype) then
                    vim.cmd("normal! " .. enter)
                    return
                end

                leap_remote.action()
            end)
        end,
    },
    {
        "echasnovski/mini.bracketed",
        lazy = true,
        keys = { "[", "]" },
        opts = {
            comment = { suffix = "k" },
            buffer = { suffix = "" },
            file = { suffix = "" },
            indent = { suffix = "" },
            location = { suffix = "" },
            oldfile = { suffix = "" },
            treesitter = { suffix = "" },
            undo = { suffix = "" },
            window = { suffix = "" },
            yank = { suffix = "" },
        },
    },
}
