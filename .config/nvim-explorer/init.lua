vim.cmd("source ~/.vimrc")

require("util")
require("options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
        opts = {
            {
                paste_window = { yank_register = "x" },
            },
        },
        keys = {
            { "x", [["xy]] },
        },
    },
    { import = "plugins.themes" },
    { import = "plugins.editor_navigation" },
})

require("mappings")
require("autocmds")
require("current_theme")

-- Explorer-specific configuration

vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.laststatus = 0
