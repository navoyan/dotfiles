local schedule = require("schedule")

schedule.now(function()
    local icons = require("mini.icons")

    icons.setup()
    icons.mock_nvim_web_devicons()
end)
