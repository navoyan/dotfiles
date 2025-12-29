local schedule, config = require("schedule"), require("config")

schedule.now(function()
    vim.pack.add({
        config.github("nvim-mini/mini.icons"),
    })

    package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
    end

    require("mini.icons").setup()
end)
