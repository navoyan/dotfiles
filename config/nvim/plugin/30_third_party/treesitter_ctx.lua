local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("nvim-treesitter/nvim-treesitter-context"),
    })

    local ts_ctx = require("treesitter-context")
    ts_ctx.setup({
        mode = "cursor",
        multiline_threshold = 1,
        max_lines = 3,
    })

    map("n", "<Leader>cc", ts_ctx.toggle)
end)
