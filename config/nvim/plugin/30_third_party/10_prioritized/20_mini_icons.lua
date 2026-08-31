local schedule, config = require("schedule"), require("config")

schedule.now(function()
    vim.pack.add({
        config.github("nvim-mini/mini.icons"),
    })

    local icons = require("mini.icons")

    icons.setup()
    icons.mock_nvim_web_devicons()
end)
