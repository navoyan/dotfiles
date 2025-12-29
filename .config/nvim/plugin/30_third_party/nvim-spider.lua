local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("chrisgrieser/nvim-spider"),
    })

    map("i", "<C-BS>", function()
        if config.is_multicursor_mode() then
            return "<C-w>"
        end

        local b = "<Cmd>lua require('spider').motion('b')<CR>"
        return "<Esc>cv" .. b
    end, {
        remap = true,
        expr = true,
    })
end)
