local schedule, config = require("schedule"), require("config")

schedule.now(function()
    vim.pack.add({
        config.github("mrjones2014/codesettings.nvim"),
    })
end)
