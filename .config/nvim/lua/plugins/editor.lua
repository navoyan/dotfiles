return {
    {
        "nvimtools/hydra.nvim",
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "echasnovski/mini.nvim",
        },
        lazy = false,
        config = function()
            local Hydra = require("hydra")
            Hydra.setup({
                hint = {
                    type = "statusline",
                },
            })

            local gitsigns = require("gitsigns")

            local function nav_hunk(direction)
                local mapping = {
                    forward = { "next", "]" },
                    backward = { "prev", "[" },
                }

                local gitsigns_direction, bracket = unpack(mapping[direction])

                if vim.wo.diff then
                    vim.cmd.normal({ bracket .. "c", bang = true })
                else
                    gitsigns.nav_hunk(gitsigns_direction)
                end
            end

            local jumps = {
                b = MiniBracketed.buffer,
                k = MiniBracketed.comment,
                x = MiniBracketed.conflict,
                d = MiniBracketed.diagnostic,
                f = MiniBracketed.file,
                i = MiniBracketed.indent,
                j = MiniBracketed.jump,
                l = MiniBracketed.location,
                o = MiniBracketed.oldfile,
                q = MiniBracketed.quickfix,
                t = MiniBracketed.treesitter,
                c = nav_hunk,
            }

            local function forward(jump)
                return function()
                    jump("forward")
                end
            end

            local function backward(jump)
                return function()
                    jump("backward")
                end
            end

            local head_opts = {
                desc = false,
            }

            local forward_jumps = {}
            for key, jump in pairs(jumps) do
                table.insert(forward_jumps, {
                    key,
                    forward(jump),
                    vim.deepcopy(head_opts),
                })
                table.insert(forward_jumps, {
                    string.upper(key),
                    backward(jump),
                    vim.deepcopy(head_opts),
                })
            end

            local backward_jumps = {}
            for key, jump in pairs(jumps) do
                table.insert(backward_jumps, {
                    key,
                    backward(jump),
                    vim.deepcopy(head_opts),
                })
                table.insert(backward_jumps, {
                    string.upper(key),
                    forward(jump),
                    vim.deepcopy(head_opts),
                })
            end

            Hydra({
                -- string? only used in auto-generated hint
                name = "Hydra (Forward)",

                -- string | string[] modes where the hydra exists, same as `vim.keymap.set()` accepts
                mode = "n",

                -- string? key required to activate the hydra, when excluded, you can use
                -- Hydra:activate()
                body = "]",
                -- these are explained below
                heads = forward_jumps,
            })

            Hydra({
                -- string? only used in auto-generated hint
                name = "Hydra (Backward)",

                -- string | string[] modes where the hydra exists, same as `vim.keymap.set()` accepts
                mode = "n",

                -- string? key required to activate the hydra, when excluded, you can use
                -- Hydra:activate()
                body = "[",
                -- these are explained below
                heads = backward_jumps,
            })
        end,
    },
    {
        "gbprod/yanky.nvim",
        opts = {
            highlight = { timer = 150, on_yank = false },
            preserve_cursor_position = {
                enabled = true,
            },
        },
        keys = {
            {
                "<leader>p",
                "<cmd>YankyRingHistory<cr>",
                mode = { "n", "x" },
                desc = "Open Yank History",
            },
            { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
            { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
            { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
            { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
            { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
            { "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Put Text After Selection" },
            { "<C-n>", "<Plug>(YankyNextEntry)", desc = "Put Text After Selection" },
            { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
            { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
            { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
            { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
            { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
            { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
            { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
            { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
            { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
            { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
        },
    },
}
