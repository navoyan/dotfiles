local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("nvim-lua/plenary.nvim"),
        {
            src = config.github("epwalsh/obsidian.nvim"),
            version = vim.version.range("*"),
        },
    })

    require("obsidian").setup({
        workspaces = {
            {
                name = "work",
                path = "~/vaults/work",
            },
            {
                name = "personal",
                path = "~/vaults/personal",
            },
        },
    })

    map("n", "<Leader>of", "<Cmd>ObsidianQuickSwitch<CR>")
    map("n", "<Leader>ot", "<Cmd>ObsidianToday<CR>")
    map("n", "<Leader>od", "<Cmd>ObsidianDailies<CR>")
    map("n", "<Leader>ow", "<Cmd>ObsidianWorkspace<CR>")
end)
