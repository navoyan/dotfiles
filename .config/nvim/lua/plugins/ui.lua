return {
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
            views = {
                mini = {
                    reverse = false,
                    timeout = 5000,
                },
                cmdline_popup = {
                    border = {
                        style = "single",
                    },
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
        "folke/snacks.nvim",
        version = "*",
        lazy = false,
        opts = {
            -- ISSUE: https://github.com/neovim/neovim/issues/33067
            -- statuscolumn = {
            --     left = { "sign" },
            --     right = { "git" },
            -- },
            words = {
                debounce = 10,
            },
            indent = {
                animate = {
                    enabled = false,
                },
                scope = {
                    enabled = false,
                },
            },
            image = {},
            dashboard = {
                sections = {
                    { section = "header" },
                    { section = "startup" },
                },
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
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
