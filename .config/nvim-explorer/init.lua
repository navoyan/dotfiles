vim.cmd("source ~/.vimrc")

require("options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "mikesmithgh/kitty-scrollback.nvim",
        version = "*",
        lazy = true,
        cmd = {
            "KittyScrollbackGenerateKittens",
            "KittyScrollbackCheckHealth",
            "KittyScrollbackGenerateCommandLineEditing",
        },
        event = { "User KittyScrollbackLaunch" },
        opts = {},
    },
    { import = "plugins.themes" },
    { import = "plugins.editor_navigation" },
})

require("mappings")
require("autocmds")
require("current_theme")

-- Explorer-specific configuration

vim.opt.modifiable = false
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.laststatus = 0

vim.keymap.set("n", "q", "<cmd>quit!<cr>")
