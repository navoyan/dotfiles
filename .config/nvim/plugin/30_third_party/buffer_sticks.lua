local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("ahkohd/buffer-sticks.nvim"),
    })

    local sticks = require("buffer-sticks")

    local highlights = require("buffer-sticks.highlights")
    local original_hl_setup = highlights.setup
    highlights.setup = function()
        original_hl_setup()
        vim.api.nvim_set_hl(0, "BufferSticksBackground", { link = "NormalFloat" })
    end

    sticks.setup({
        show_indicators = false,
        preview = { enabled = false },
        filter = { buftypes = { "terminal" } },
        position = "center",
        border = "single",
        transparent = false,
        highlights = {
            active = { link = "Statement" },
            alternate = { link = "Normal" },
            inactive = { link = "Normal" },
            active_modified = { link = "Statement" },
            alternate_modified = { link = "Normal" },
            inactive_modified = { link = "Constant" },
            label = { link = "Comment" },
            filter_selected = { link = "Statement" },
            filter_title = { link = "Comment" },
            list_selected = { link = "Statement" },
        },
        list = {
            keys = {
                close_buffer = "<BS>", -- Key to close buffer in list mode
            },
        },
    })

    map("n", ";", function()
        sticks.jump()
    end)
end)
