local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({ config.github("stevearc/conform.nvim") })

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
            json = { "jq" },
            just = { "just" },
        },
        formatters = {
            jq = {
                append_args = { "--indent", "4" },
                condition = function(_, ctx)
                    return vim.fs.basename(ctx.filename) ~= "lazy-lock.json"
                end,
            },
        },
    })

    map("n", "<Leader>cf", function()
        conform.format(format_cfg(0))
    end)
end)
