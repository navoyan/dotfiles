local schedule = require("schedule")

schedule.later(function()
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
