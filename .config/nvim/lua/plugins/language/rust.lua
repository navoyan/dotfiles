return {
    {
        "mrcjkb/rustaceanvim",
        version = "*",
        ft = { "rust" },
        opts = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                capabilities = {
                    experimental = {
                        snippetTextEdit = false,
                    },
                },
                on_attach = function(_, bufnr)
                    local ra_client_name = "rust-analyzer"

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    map("n", "<leader>cL", function()
                        local check_cmd = vim.tbl_get(
                            vim.lsp.config,
                            "rust-analyzer",
                            "settings",
                            "rust-analyzer",
                            "check",
                            "command"
                        ) or "check"

                        check_cmd = check_cmd == "check" and "clippy" or "check"

                        -- NOTE: rustaceanvim extends `opts.server.default_settings`
                        -- with `vim.lsp.config[ra_client_name].default_settings`
                        vim.lsp.config(ra_client_name, {
                            default_settings = {
                                ["rust-analyzer"] = {
                                    check = {
                                        command = check_cmd,
                                    },
                                },
                            },
                        })

                        vim.cmd.RustAnalyzer("restart")
                    end)
                end,
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
                        rustfmt = {
                            extraArgs = { "+nightly" },
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
        event = { "BufRead Cargo.toml" },
        opts = {
            enable_update_available_warning = false,
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
