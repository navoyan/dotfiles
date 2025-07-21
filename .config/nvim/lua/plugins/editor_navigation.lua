return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        keys = {
            { "<Bs>", mode = { "n", "x", "o" } },
            { "<Cr>", mode = { "n", "x", "o" } },
            { "r", mode = "o" },
            { "R", mode = { "o", "x" } },
        },
        config = function(_, opts)
            local map = vim.keymap.set

            local flash = require("flash")

            flash.setup(opts)

            map({ "n", "x", "o" }, "<Bs>", flash.jump)
            map({ "n", "x", "o" }, "<Cr>", flash.treesitter)
            map("o", "r", flash.remote)
            map({ "o", "x" }, "R", flash.treesitter_search)
        end,
        ---@type Flash.Config
        opts = {
            modes = {
                char = {
                    enabled = true,
                    multi_line = false,
                    keys = { "f", "f", "t", "t", [";"] = "m", "," },
                    highlight = { backdrop = false },
                    char_actions = function(_)
                        return {
                            ["m"] = "next",
                            [","] = "prev",
                            -- note: disable `f`/`f`/`t`/`t` enhanced behaviour
                            --
                            -- [motion:lower()] = "next",
                            -- [motion:upper()] = "prev",
                        }
                    end,
                },
                search = {
                    enabled = false,
                },
            },
        },
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
