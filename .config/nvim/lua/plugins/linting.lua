return {
    {
        "mfussenegger/nvim-lint",
        dependencies = {
            "j-hui/fidget.nvim",
        },
        opts = {
            linters_by_ft = {
                rust = { "clippy" },
            },
        },
        keys = {
            "<leader>L",
        },
        config = function(_, opts)
            local lint = require("lint")

            lint.linters_by_ft = opts.linters_by_ft

            local function fidget_linters(h)
                local handlers = h or {}
                local linters = lint.get_running(0)
                if #linters == 0 then
                    for _, handle in pairs(handlers) do
                        handle:finish()
                    end
                    return
                end

                -- add missing handlers to fidget
                for _, linter in ipairs(linters) do
                    if not handlers[linter] then
                        handlers[linter] = require("fidget.progress").handle.create({
                            title = "",
                            message = "",
                            lsp_client = { name = linter },
                        })
                    end
                end

                -- tell fidget to finish linters that are done running
                for lntr, handle in pairs(handlers) do
                    if not vim.tbl_contains(linters, lntr) then
                        handle:finish()
                    end
                end
                vim.defer_fn(function()
                    fidget_linters(handlers)
                end, 50)
            end

            vim.keymap.set("n", "<leader>L", function()
                lint.try_lint()
                fidget_linters()
            end)
        end,
    },
}
