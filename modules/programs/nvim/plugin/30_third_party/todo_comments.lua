local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("folke/todo-comments.nvim"),
    })

    require("todo-comments").setup({ signs = false })
end)
