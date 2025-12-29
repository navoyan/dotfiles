local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("nvim-mini/mini.bracketed"),
    })

    require("mini.bracketed").setup({
        comment = { suffix = "k" },
        buffer = { suffix = "" },
        file = { suffix = "" },
        indent = { suffix = "" },
        location = { suffix = "" },
        oldfile = { suffix = "" },
        treesitter = { suffix = "" },
        undo = { suffix = "" },
        window = { suffix = "" },
        yank = { suffix = "" },
    })
end)
