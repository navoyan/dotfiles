local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.g.nvim_surround_no_mappings = true

    vim.pack.add({
        { src = config.github("kylechui/nvim-surround"), version = vim.version.range("*") },
    })

    map("n", "sa", "<Plug>(nvim-surround-normal)")
    map("n", "sA", "<Plug>(nvim-surround-normal-line)")

    map("v", "sa", "<Plug>(nvim-surround-visual)")
    map("v", "sA", "<Plug>(nvim-surround-visual-line)")

    map("n", "sd", "<Plug>(nvim-surround-delete)")
    map("n", "sr", "<Plug>(nvim-surround-change)")
    map("n", "sR", "<Plug>(nvim-surround-change-line)")
end)
