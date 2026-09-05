local schedule = require("schedule")

schedule.later(function()
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
