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
                on_attach = function(_, bufnr)
                    vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
                        buffer = bufnr,
                        group = vim.api.nvim_create_augroup("autosave", { clear = true }),
                        callback = function()
                            if
                                vim.bo.modified
                                and not vim.bo.readonly
                                and vim.fn.expand("%") ~= ""
                                and vim.bo.buftype == ""
                            then
                                vim.api.nvim_command("silent update")
                                vim.cmd.RustLsp("flyCheck")
                            end
                        end,
                    })
                end,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {
                        checkOnSave = false,
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
        opts = {},
    },
}
