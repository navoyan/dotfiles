local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("stevearc/conform.nvim"),
    })

    local conform = require("conform")

    local disabled_lsp_fallback_fts = {
        c = true,
        cpp = true,
    }
    local function format_cfg(bufnr)
        return {
            async = false,
            timeout_ms = 500,
            lsp_fallback = not disabled_lsp_fallback_fts[vim.bo[bufnr].filetype],
        }
    end

    local disabled_jq_filenames = {
        ["nvim-pack-lock.json"] = true,
    }
    local function jq_condition(_, ctx)
        local name = vim.fs.basename(ctx.filename)
        return not disabled_jq_filenames[name]
    end

    conform.setup({
        notify_on_error = true,
        format_on_save = format_cfg,
        formatters_by_ft = {
            lua = { "stylua" },
            bzl = { "buildifier" },
            json = { "jq" },
            just = { "just" },
            xml = { "xmlstarlet" },
            javascript = { "biome" },
            typescript = { "biome" },
        },
        formatters = {
            jq = {
                append_args = { "--indent", "4" },
                condition = jq_condition,
            },
        },
    })

    map("n", "<Leader>cf", function()
        conform.format(format_cfg(0))
    end)
end)
