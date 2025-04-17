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
                enableOnVimEnter = false,
                skipEnteringNoNeckPainBuffer = false,
            },
            mappings = {
                enabled = false,
            },
            integrations = {
                dashboard = {
                    enabled = true,
                },
            },
        },
    },
    {
        "cbochs/grapple.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        opts = {
            scope = "git_branch",
            icons = true,
            quick_select = "123456789",
        },
        keys = {
            { ";", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },

            { "<c-s>", "<cmd>Grapple toggle<cr>", desc = "Toggle tag" },
            -- { "H", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
            -- { "L", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
        },
    },
}
