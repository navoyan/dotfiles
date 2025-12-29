local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("gbprod/yanky.nvim"),
    })

    require("yanky").setup({
        highlight = { timer = 150, on_yank = false },
        preserve_cursor_position = {
            enabled = true,
        },
    })

    map({ "n", "x" }, "<Leader>p", "<Cmd>YankyRingHistory<CR>")
    map({ "n", "x" }, "y", "<Plug>(YankyYank)")
    map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
    map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
    map("n", "<C-p>", "<Plug>(YankyPreviousEntry)")
    map("n", "<C-n>", "<Plug>(YankyNextEntry)")
    map("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
    map("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
    map("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
    map("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")
    map("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
    map("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
    map("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
    map("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")
    map("n", "=p", "<Plug>(YankyPutAfterFilter)")
    map("n", "=P", "<Plug>(YankyPutBeforeFilter)")
end)
