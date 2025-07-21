return {
    "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
    {
        "stevearc/conform.nvim",
        opts = {
            notify_on_error = true,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                return {
                    async = false,
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
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
        },
    },
}
