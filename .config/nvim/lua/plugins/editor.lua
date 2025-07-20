return {
    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            local map = vim.keymap.set

            -- Add or skip cursor above/below the main cursor.
            map({ "n", "x" }, "<up>", function()
                mc.lineAddCursor(-1)
            end)
            map({ "n", "x" }, "<down>", function()
                mc.lineAddCursor(1)
            end)

            -- Add or skip adding a new cursor by matching word/selection
            map({ "n", "x" }, "<leader>n", function()
                mc.matchAddCursor(1)
            end)
            map({ "n", "x" }, "<leader>sn", function()
                mc.matchSkipCursor(1)
            end)
            map({ "n", "x" }, "<leader>N", function()
                mc.matchAddCursor(-1)
            end)
            map({ "n", "x" }, "<leader>S", function()
                mc.matchSkipCursor(-1)
            end)

            -- Disable and enable cursors.
            map("n", "<c-q>", mc.toggleCursor)
            map("x", "<c-q>", mc.visualToCursors)

            -- Mappings defined in a keymap layer only apply when there are
            -- multiple cursors. This lets you have overlapping mappings.
            mc.addKeymapLayer(function(layerSet)
                -- Select a different cursor as the main one.
                layerSet({ "n", "x" }, "<left>", mc.prevCursor)
                layerSet({ "n", "x" }, "<right>", mc.nextCursor)

                -- Delete the main cursor.
                layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

                -- Align cursor columns.
                layerSet("n", "<leader>a", mc.alignCursors)

                -- Clone every cursor and disable the originals.
                map({ "n", "x" }, "<leader><c-q>", mc.duplicateCursors)

                -- Enable and clear cursors using escape.
                layerSet("n", "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)

            -- Split visual selections by regex.
            map("x", "S", mc.splitCursors)

            -- match new cursors within visual selections by regex.
            map("x", "M", mc.matchCursors)

            -- bring back cursors if you accidentally clear them
            map("n", "<leader>gv", mc.restoreCursors)

            -- Add a cursor for all matches of cursor word/selection in the document.
            map({ "n", "x" }, "<leader>A", mc.matchAllAddCursors)

            -- Append/insert for each line of visual selections.
            -- Similar to block selection insertion.
            map("x", "I", mc.insertVisual)
            map("x", "A", mc.appendVisual)

            -- Add a cursor and jump to the next/previous search result.
            map("n", "<leader>/n", function()
                mc.searchAddCursor(1)
            end)
            map("n", "<leader>/N", function()
                mc.searchAddCursor(-1)
            end)

            -- Jump to the next/previous search result without adding a cursor.
            map("n", "<leader>/s", function()
                mc.searchSkipCursor(1)
            end)
            map("n", "<leader>/S", function()
                mc.searchSkipCursor(-1)
            end)

            -- Add a cursor to every search result in the buffer.
            map("n", "<leader>/A", mc.searchAllAddCursors)

            -- Pressing `gaip` will add a cursor on each line of a paragraph.
            map("n", "ga", mc.addCursorOperator)

            -- Pressing `<leader>miwap` will create a cursor in every match of the
            -- string captured by `iw` inside range `ap`.
            -- This action is highly customizable, see `:h multicursor-operator`.
            map({ "n", "x" }, "gs", mc.operator)

            -- Customize how cursors look.
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { link = "Cursor" })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn" })
            hl(0, "MultiCursorMatchPreview", { link = "Search" })
            hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
        end,
    },
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
                hint = false,
            })

            local gitsigns = require("gitsigns")

            local function nav_hunk(direction)
                local mapping = {
                    forward = { "next", "]" },
                    backward = { "prev", "[" },
                }

                local gitsigns_direction, bracket = mapping[direction][1], mapping[direction][2]

                if vim.wo.diff then
                    vim.cmd.normal({ bracket .. "c", bang = true })
                else
                    gitsigns.nav_hunk(gitsigns_direction, { wrap = true, navigation_message = false })
                    vim.wait(5)
                end
            end

            local jumps = {
                k = MiniBracketed.comment,
                x = MiniBracketed.conflict,
                d = MiniBracketed.diagnostic,
                j = MiniBracketed.jump,
                q = MiniBracketed.quickfix,
                c = nav_hunk,
            }

            local function forward(jump)
                return function()
                    return jump("forward")
                end
            end

            local function backward(jump)
                return function()
                    return jump("backward")
                end
            end

            local function head_opts()
                return {
                    desc = false,
                }
            end

            local forward_jumps = {}
            for key, jump in pairs(jumps) do
                table.insert(forward_jumps, {
                    key,
                    forward(jump),
                    head_opts(),
                })
                table.insert(forward_jumps, {
                    string.upper(key),
                    backward(jump),
                    head_opts(),
                })
            end

            local backward_jumps = {}
            for key, jump in pairs(jumps) do
                table.insert(backward_jumps, {
                    key,
                    backward(jump),
                    head_opts(),
                })
                table.insert(backward_jumps, {
                    string.upper(key),
                    forward(jump),
                    head_opts(),
                })
            end

            local lualine = require("lualine")

            local function hydra_config()
                return {
                    color = "pink",
                    on_enter = function()
                        vim.bo.modifiable = false
                        lualine.refresh({ place = { "statusline" } })
                    end,
                    on_exit = function()
                        lualine.refresh({ place = { "statusline" } })
                    end,
                }
            end

            -- Forward
            Hydra({
                body = "]",
                mode = "n",
                config = hydra_config(),
                heads = forward_jumps,
            })

            -- Backward
            Hydra({
                body = "[",
                mode = "n",
                config = hydra_config(),
                heads = backward_jumps,
            })
        end,
    },
    {
        "chrisgrieser/nvim-spider",
        lazy = true,
        keys = {
            { "<C-Bs>", mode = { "i" } },
        },
        config = function()
            local b = "<cmd>lua require('spider').motion('b')<CR>"
            vim.keymap.set("i", "<C-Bs>", "<Esc>cv" .. b, { remap = true })
        end,
    },
    {
        "gbprod/substitute.nvim",
        dependencies = { "gbprod/yanky.nvim" },
        lazy = true,
        keys = { "x", "X" },
        config = function()
            local substitute = require("substitute")

            substitute.setup({
                on_substitute = require("yanky.integration").substitute(),
                highlight_substituted_text = {
                    timer = 150,
                },
            })

            vim.keymap.set("n", "x", substitute.operator, { noremap = true })
            vim.keymap.set("n", "xx", substitute.line, { noremap = true })
            vim.keymap.set("n", "X", substitute.eol, { noremap = true })
            vim.keymap.set("x", "x", substitute.visual, { noremap = true })
        end,
    },
    {
        "gbprod/yanky.nvim",
        dependencies = { "folke/snacks.nvim" },
        lazy = true,
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
