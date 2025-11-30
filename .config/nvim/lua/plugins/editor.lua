return {
    {
        -- Better Around/Inside textobjects
        "echasnovski/mini.ai",
        dependencies = {
            { "echasnovski/mini.extra", opts = {} },
        },
        lazy = true,
        keys = {
            { "i", mode = { "o", "x" } },
            { "a", mode = { "o", "x" } },
            { "g[", mode = { "n", "o", "x" } },
            { "g]", mode = { "n", "o", "x" } },
        },
        opts = function()
            return {
                custom_textobjects = {
                    g = MiniExtra.gen_ai_spec.buffer(),
                    i = MiniExtra.gen_ai_spec.indent(),
                    e = MiniExtra.gen_ai_spec.line(),
                    x = MiniExtra.gen_ai_spec.number(),
                },
            }
        end,
    },
    {
        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        "echasnovski/mini.surround",
        lazy = true,
        keys = {
            { "sa", mode = { "x", "n" } },
            { "sd", mode = { "x", "n" } },
            { "sf", mode = { "x", "n" } },
            { "sF", mode = { "x", "n" } },
            { "sh", mode = { "x", "n" } },
            { "sr", mode = { "x", "n" } },
        },
        opts = {
            mappings = {
                update_n_lines = "", -- Update `n_lines`
            },
        },
    },
    {
        "echasnovski/mini.move",
        lazy = true,
        keys = {
            { "<C-S-h>", mode = { "x", "n" } },
            { "<C-S-l>", mode = { "x", "n" } },
            { "<C-S-j>", mode = { "x", "n" } },
            { "<C-S-k>", mode = { "x", "n" } },
        },
        opts = {
            mappings = {
                -- Move visual selection in Visual mode
                left = "<C-S-h>",
                right = "<C-S-l>",
                down = "<C-S-j>",
                up = "<C-S-k>",

                -- Cove current line in Normal mode
                line_left = "<C-S-h>",
                line_right = "<C-S-l>",
                line_down = "<C-S-j>",
                line_up = "<C-S-k>",
            },
        },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
        config = function(_, opts)
            local autopairs = require("nvim-autopairs")

            -- HACK: disable autopairs in multicursor mode
            local state_mt = {
                __index = function(_, key)
                    return key == "disabled" and Util.is_multicursor_mode()
                end,
            }

            autopairs.state.disabled = nil
            setmetatable(autopairs.state, state_mt)

            autopairs.setup(opts)
        end,
    },
    {
        "gbprod/substitute.nvim",
        dependencies = { "gbprod/yanky.nvim" },
        lazy = true,
        keys = {
            "x",
            "xx",
            "X",
            { "x", mode = "x" },
        },
        config = function()
            local substitute = require("substitute")

            substitute.setup({
                on_substitute = require("yanky.integration").substitute(),
                preserve_cursor_position = true,
                highlight_substituted_text = {
                    timer = 150,
                },
            })

            local map = vim.keymap.set

            map("n", "x", substitute.operator, { noremap = true })
            map("n", "xx", substitute.line, { noremap = true })
            map("n", "X", substitute.eol, { noremap = true })
            map("x", "x", substitute.visual, { noremap = true })
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
    {
        "chrisgrieser/nvim-spider",
        event = "InsertEnter",
        lazy = true,
        keys = {
            {
                "<C-Bs>",
                function()
                    if Util.is_multicursor_mode() then
                        return "<C-w>"
                    end

                    local b = "<cmd>lua require('spider').motion('b')<CR>"
                    return "<Esc>cv" .. b
                end,
                mode = "i",
                remap = true,
                expr = true,
            },
        },
    },
    {
        "jake-stewart/multicursor.nvim",
        branch = "*",
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup({
                hlsearch = true,
            })

            local map = vim.keymap.set

            -- Add cursor above/below the main cursor.
            map({ "n", "x" }, "<S-Up>", function()
                mc.lineAddCursor(-1)
            end)
            map({ "n", "x" }, "<S-Down>", function()
                mc.lineAddCursor(1)
            end)

            local visual_mode = {
                v = true,
                V = true,
                [""] = true,
            }
            local function match_or_search_cursor_fn(opts)
                return function()
                    if visual_mode[vim.fn.mode()] then
                        opts.match_fn(opts.direction)
                    elseif vim.v.hlsearch == 1 then
                        opts.search_fn(opts.direction)
                    else
                        opts.match_fn(opts.direction)
                    end
                end
            end

            -- Add a new cursor by matching word / selection / search result
            map(
                { "n", "x" },
                "sn",
                match_or_search_cursor_fn({
                    direction = 1,
                    match_fn = mc.matchAddCursor,
                    search_fn = mc.searchAddCursor,
                })
            )
            map(
                { "n", "x" },
                "sN",
                match_or_search_cursor_fn({
                    direction = -1,
                    match_fn = mc.matchAddCursor,
                    search_fn = mc.searchAddCursor,
                })
            )

            -- Mappings defined in a keymap layer only apply when there are
            -- multiple cursors. This lets you have overlapping mappings.
            mc.addKeymapLayer(function(layer_map)
                -- Select a different cursor as the main one.
                layer_map({ "n", "x" }, "[", mc.prevCursor)
                layer_map({ "n", "x" }, "]", mc.nextCursor)

                -- Skip cursor above/below the main cursor.
                map({ "n", "x" }, "<S-C-Up>", function()
                    mc.lineSkipCursor(-1)
                end)
                map({ "n", "x" }, "<S-C-Down>", function()
                    mc.lineSkipCursor(1)
                end)

                -- Add or skip adding a new cursor by matching word / selection / search result.
                layer_map(
                    { "n", "x" },
                    "n",
                    match_or_search_cursor_fn({
                        direction = 1,
                        match_fn = mc.matchAddCursor,
                        search_fn = mc.searchAddCursor,
                    })
                )
                layer_map(
                    { "n", "x" },
                    "sn",
                    match_or_search_cursor_fn({
                        direction = 1,
                        match_fn = mc.matchSkipCursor,
                        search_fn = mc.searchSkipCursor,
                    })
                )
                layer_map(
                    { "n", "x" },
                    "N",
                    match_or_search_cursor_fn({
                        direction = -1,
                        match_fn = mc.matchAddCursor,
                        search_fn = mc.searchAddCursor,
                    })
                )
                layer_map(
                    { "n", "x" },
                    "sN",
                    match_or_search_cursor_fn({
                        direction = -1,
                        match_fn = mc.matchSkipCursor,
                        search_fn = mc.searchSkipCursor,
                    })
                )

                -- Delete the main cursor.
                layer_map({ "n", "x" }, "sx", mc.deleteCursor)

                -- Align cursor columns.
                layer_map("n", "sc", mc.alignCursors)

                -- Clone every cursor and disable the originals.
                layer_map({ "n", "x" }, "ssm", mc.duplicateCursors)

                -- Enable and clear cursors using escape.
                layer_map("n", "<Esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)

            -- Disable and enable cursors.
            map("n", "sm", mc.toggleCursor)
            map("x", "sm", mc.visualToCursors)

            -- Bring back previous cursors.
            map("n", "sv", mc.restoreCursors)

            -- Append/insert for each line of visual selections.
            -- Similar to block selection insertion.
            map("x", "I", mc.insertVisual)
            map("x", "A", mc.appendVisual)

            local function au_after_search(fn)
                vim.fn.setreg("/", "")
                vim.api.nvim_create_autocmd("CmdlineLeave", {
                    pattern = "/",
                    once = true,
                    callback = vim.schedule_wrap(function()
                        fn()
                        vim.fn.setreg("/", "")
                    end),
                })
            end

            -- Add a cursor to every search result in the buffer.
            map("n", "s/", function()
                au_after_search(mc.searchAllAddCursors)
                return "/"
            end, { expr = true })

            -- Add a cursor to every search result in the visual selection.
            map("x", "s/", function()
                au_after_search(mc.searchAllAddCursors)
                return "<Esc>/\\%V"
            end, { expr = true })

            -- Split visual selections by search result.
            map("x", "S", function()
                au_after_search(function()
                    vim.cmd("normal! gv")
                    local search = vim.fn.getreg("/")
                    -- strip `\%V` ("in previous selection") from search
                    search = search:sub(4, -1)
                    mc.splitCursors(search)
                end)
                return "<Esc>/\\%V"
            end, { expr = true })

            -- Example: pressing `seip` will add a cursor on each line of a paragraph.
            map("n", "se", mc.addCursorOperator)

            -- Example: pressing `sgiwap` will create a cursor in every match of the
            -- string captured by `iw` inside range `ap`.
            map({ "n", "x" }, "sg", mc.operator)
        end,
    },
}
