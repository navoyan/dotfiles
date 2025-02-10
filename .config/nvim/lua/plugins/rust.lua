return {
    {
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        ft = { "rust" },
        opts = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {
                        checkOnSave = true,
                        check = {
                            command = "check",
                        },
                        cargo = {
                            buildScripts = {
                                rebuildOnSave = true,
                            },
                        },
                        imports = {
                            granularity = {
                                group = "module",
                                enforce = true,
                            },
                            prefix = "crate",
                        },
                    },
                },
            },
            -- DAP configuration
            dap = {},
        },
        config = function(_, opts)
            vim.g.rustaceanvim = opts
        end,
    },
    {
        "saecki/crates.nvim",
        tag = "stable",
        opts = {
            completion = {
                crates = {
                    enabled = true,
                },
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        },
    },
}
