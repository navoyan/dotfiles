local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("nvim-mini/mini.statusline"),
    })

    local statusline = require("mini.statusline")

    local function content_active()
        local searchcount = statusline.section_searchcount({})
        searchcount = searchcount ~= "" and "[" .. searchcount .. "]" or ""

        return searchcount
    end

    statusline.setup({
        content = {
            active = content_active,
        },
    })
end)
