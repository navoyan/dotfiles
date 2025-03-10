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
    {
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        lazy = false,
        opts = {
            width = 120,
            autocmds = {
                enableOnVimEnter = true,
                skipEnteringNoNeckPainBuffer = true,
            },
            mappings = {
                enabled = true,
            },
            integrations = {
                dashboard = {
                    enabled = true,
                },
            },
        },
    },
    {
        "ghillb/cybu.nvim",
        enabled = true,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-lua/plenary.nvim",
        },
        opts = {
            display_time = 500,
            style = {
                highlights = { -- see highlights via :highlight
                    current_buffer = "CybuFocus", -- current / selected buffer
                    adjacent_buffers = "CybuBorder", -- buffers not in focus
                    background = "CybuBorder", -- window background
                    border = "CybuBorder", -- border of the window
                },
            },
        },
        keys = {
            {
                "H",
                mode = { "n", "v" },
                "<plug>(CybuLastusedPrev)",
            },
            {
                "L",
                mode = { "n", "v" },
                "<plug>(CybuLastusedNext)",
            },
        },
    },
}
