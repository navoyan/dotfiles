return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
            lsp = {
                progress = {
                    enabled = false,
                },
            },
            presets = {
                inc_rename = true,
            },
            views = {
                mini = {
                    reverse = false,
                    timeout = 5000,
                },
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            {
                "folke/snacks.nvim",
                optional = true,
            },
        },
    },
    {
        "smjonas/inc-rename.nvim",
        opts = {},
    },
    {
        "echasnovski/mini.icons",
        lazy = true,
        opts = {},
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
    -- Useful status updates for LSP.
    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                window = {
                    winblend = 0, -- Background color opacity in the notification window
                },
            },
        },
    },
}
