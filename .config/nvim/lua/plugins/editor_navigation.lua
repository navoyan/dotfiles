return {
    {
        "ggandor/leap.nvim",
        lazy = false,
        opts = {
            safe_labels = {},
        },
        config = function(_, opts)
            local default_opts = vim.deepcopy(require("leap.opts").default)
            require("leap").setup(opts)

            local map = vim.keymap.set

            map({ "n", "x", "o" }, "<Bs>", "<Plug>(leap)")

            -- To increase/decrease the selection in a clever-f-like manner,
            -- with the trigger key itself (vRRRRrr...).
            -- The default keys (<enter>/<backspace>) also work
            local ts_opts = require("leap.user").with_traversal_keys("R", "r")
            ts_opts.safe_labels = default_opts.safe_labels
            map({ "n", "x", "o" }, "R", function()
                require("leap.treesitter").select({ opts = ts_opts })
            end)

            local leap_remote = require("leap.remote")

            map({ "x", "o" }, "<Enter>", leap_remote.action)

            -- Default <Enter> behaviour for these buftypes
            local default_enter_bt = {
                quickfix = true,
                nofile = true,
                help = true,
                prompt = true,
                terminal = true,
            }

            local enter = vim.keycode("<Enter>")
            map("n", "<Enter>", function()
                if default_enter_bt[vim.bo.buftype] then
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
