return {
    "folke/flash.nvim",
    event = "VeryLazy",
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
    keys = {
        {
            "<Bs>",
            mode = { "n", "x", "o" },
            function()
                require("flash").jump()
            end,
            desc = "Flash",
        },
        {
            "Q",
            mode = { "n", "x", "o" },
            function()
                require("flash").treesitter()
            end,
            desc = "Flash Treesitter",
        },
        {
            "r",
            mode = { "o", "x" },
            function()
                require("flash").remote()
            end,
            desc = "Remote Flash",
        },
        {
            "R",
            mode = { "o", "x" },
            function()
                require("flash").treesitter_search()
            end,
            desc = "Treesitter Search",
        },
    },
}
