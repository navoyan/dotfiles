local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("windwp/nvim-autopairs"),
    })

    local autopairs = require("nvim-autopairs")

    -- HACK: disable autopairs in multicursor mode
    local state_mt = {
        __index = function(_, key)
            return key == "disabled" and config.is_multicursor_mode()
        end,
    }

    autopairs.state.disabled = nil
    setmetatable(autopairs.state, state_mt)

    autopairs.setup()
end)
