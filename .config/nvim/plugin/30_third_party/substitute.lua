local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("gbprod/yanky.nvim"),
        config.github("gbprod/substitute.nvim"),
    })

    local substitute = require("substitute")

    substitute.setup({
        on_substitute = require("yanky.integration").substitute(),
        preserve_cursor_position = true,
        highlight_substituted_text = {
            timer = 150,
        },
    })

    map("n", "x", substitute.operator, { noremap = true })
    map("n", "xx", substitute.line, { noremap = true })
    map("n", "X", substitute.eol, { noremap = true })
    map("x", "x", substitute.visual, { noremap = true })
end)
