local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.on_event("User~KittyScrollbackLaunch", function()
    vim.pack.add({
        {
            src = config.github("mikesmithgh/kitty-scrollback.nvim"),
            version = vim.version.range("*"),
        },
    })

    require("kitty-scrollback").setup({
        {
            paste_window = { yank_register = "x" },
        },
    })

    -- Yank into paste window
    map("n", "x", [["xy]])
end)
