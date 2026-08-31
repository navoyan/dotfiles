local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("nvim-lua/plenary.nvim"),
        {
            src = config.github("obsidian-nvim/obsidian.nvim"),
            version = vim.version.range("*"),
        },
    })

    require("obsidian").setup({
        legacy_commands = false,
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

    map("n", "<Leader>of", "<Cmd>Obsidian quick_switch<CR>")
    map("n", "<Leader>ot", "<Cmd>Obsidian today<CR>")
    map("n", "<Leader>od", "<Cmd>Obsidian dailies<CR>")
    map("n", "<Leader>ow", "<Cmd>Obsidian workspace<CR>")
end)
