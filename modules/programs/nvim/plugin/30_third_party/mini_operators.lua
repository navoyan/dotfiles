local schedule = require("schedule")

schedule.later(function()
    require("mini.operators").setup({
        replace = {
            prefix = "",
        },
        exchange = {
            prefix = "",
        },
    })
end)
