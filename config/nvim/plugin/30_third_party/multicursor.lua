local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("jake-stewart/multicursor.nvim"),
    })

    local mc = require("multicursor-nvim")
    mc.setup({
        hlsearch = true,
    })

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
end)
