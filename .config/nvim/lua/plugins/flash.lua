return {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
        { "<Bs>", mode = { "n", "x", "o" } },
        { "Q", mode = { "n", "x", "o" } },
        { "r", mode = "o" },
        { "R", mode = { "o", "x" } },
    },
    config = function(_, opts)
        local map = vim.keymap.set

        local flash = require("flash")

        flash.setup(opts)

        map({ "n", "x", "o" }, "<Bs>", flash.jump)
        map({ "n", "x", "o" }, "Q", flash.treesitter)
        map("o", "r", flash.remote)
        map({ "o", "x" }, "R", flash.treesitter_search)
    end,
    ---@type Flash.Config
    opts = {
        modes = {
            char = {
                enabled = true,
                multi_line = false,
                highlight = { backdrop = false },
                char_actions = function(_)
                    return {
                        [";"] = "next",
                        [","] = "prev",
                        -- NOTE: disable `f`/`F`/`t`/`T` enhanced behaviour
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
}
