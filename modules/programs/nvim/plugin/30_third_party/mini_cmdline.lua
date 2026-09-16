local schedule = require("schedule")

schedule.later(function()
    require("mini.cmdline").setup()
end)
