local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("cbochs/grapple.nvim"),
    })

    local Grapple = require("grapple")
    local Settings = require("grapple.settings")

    local default_settings = Settings:new()

    Grapple.setup({
        icons = true,
        quick_select = "123456789",
        tag_hook = function(window)
            -- Toggle tag for current file
            window:map("n", "a", function()
                window:close()
                Grapple.toggle()
                Grapple.open_tags()
            end)

            default_settings.tag_hook(window)
        end,
    })

    map("n", ";", "<Cmd>Grapple toggle_tags<CR>")
end)
