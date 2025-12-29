local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("mrjones2014/smart-splits.nvim"),
    })

    config.on_packchanged("smart-splits.nvim", { "install", "update" }, function()
        vim.system({ "bash", "-c", "./kitty/install-kittens.bash" })
    end)

    local splits = require("smart-splits")

    -- moving between splits
    map("n", "<M-h>", splits.move_cursor_left)
    map("n", "<M-j>", splits.move_cursor_down)
    map("n", "<M-k>", splits.move_cursor_up)
    map("n", "<M-l>", splits.move_cursor_right)
    -- resizing splits
    map("n", "<M-S-h>", splits.resize_left)
    map("n", "<M-S-j>", splits.resize_down)
    map("n", "<M-S-k>", splits.resize_up)
    map("n", "<M-S-l>", splits.resize_right)
end)
