local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.now(function()
    vim.pack.add({
        {
            src = config.github("mikesmithgh/kitty-scrollback.nvim"),
            version = vim.version.range("*"),
        },
    })

    config.new_autocmd("User", "KittyScrollbackLaunch", function()
        require("kitty-scrollback").setup({
            {
                paste_window = { yank_register = "x" },
            },
        })

        -- Yank into paste window
        map("n", "x", [["xy]])
    end)
end)
