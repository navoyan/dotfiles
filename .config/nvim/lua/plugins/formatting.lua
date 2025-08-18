return {
    { -- Detect tabstop and shiftwidth automatically
        "NMAC427/guess-indent.nvim",
        lazy = false,
        opts = {},
    },
    {
        "stevearc/conform.nvim",
        lazy = false,
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format()
                end,
            },
        },
        config = function()
            local conform = require("conform")

            local disabled_lsp_fallback_ft = {
                c = true,
                cpp = true,
            }
            local function format_cfg(bufnr)
                return {
                    async = false,
                    timeout_ms = 500,
                    lsp_fallback = not disabled_lsp_fallback_ft[vim.bo[bufnr].filetype],
                }
            end

            conform.setup({
                notify_on_error = true,
                format_on_save = format_cfg,
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "ruff_format" },
                    bzl = { "buildifier" },
                    json = { "prettier" },
                },
                formatters = {
                    prettier = {
                        condition = function(_, ctx)
                            return vim.fs.basename(ctx.filename) ~= "lazy-lock.json"
                        end,
                    },
                },
            })

            local map = vim.keymap.set

            map("n", "<leader>cf", function()
                conform.format(format_cfg(0))
            end)
        end,
    },
}
