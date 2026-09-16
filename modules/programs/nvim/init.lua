vim.cmd.source("~/.config/nvim/.vimrc")

local config = require("config")
vim.pack.add({
    config.github("nvim-mini/mini.nvim"),
})
