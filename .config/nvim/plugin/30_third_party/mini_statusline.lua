local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("nvim-mini/mini.statusline"),
    })

    local statusline = require("mini.statusline")

    local function section_mode(args)
        if config.is_hydra_mode() then
            local hydra_mode = statusline.is_truncated(args.trunc_width) and "H" or "Hydra"
            local hydra_mode_hl = "MiniStatuslineModeOther"
            return hydra_mode, hydra_mode_hl
        end

        return statusline.section_mode(args)
    end

    local function section_filename()
        -- In terminal always use plain name
        if vim.bo.buftype == "terminal" then
            return "%t"
        else
            -- Relative filename in working dir, otherwise absolute filename
            -- with 'modified', 'readonly' flags
            return vim.fn.expand("%:~:.") .. "%m%r"
        end
    end

    local function section_macro()
        local reg = vim.fn.reg_recording()
        return reg ~= "" and "Recording @" .. reg or ""
    end

    local diagnostic_signs = {
        ERROR = "%#DiagnosticError#E",
        WARN = "%#DiagnosticWarn#W",
        INFO = "%#DiagnosticInfo#I",
        HINT = "%#DiagnosticHint#H",
    }

    local last_section_git = ""
    local function content_active()
        local mode, mode_hl = section_mode({ trunc_width = 120 })

        local git = statusline.section_git({ trunc_width = 40 })
        git = git ~= "" and git or last_section_git
        last_section_git = git

        local filename = section_filename()

        local searchcount = statusline.section_searchcount({ trunc_width = 75 })
        searchcount = searchcount ~= "" and "[" .. searchcount .. "]" or ""

        local macro = section_macro()
        local diagnostics = statusline.section_diagnostics({ trunc_width = 75, signs = diagnostic_signs })
        local diff = statusline.section_diff({ trunc_width = 75 })

        return statusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineBranch", strings = { git } },
            "%<", -- Mark general truncate point
            { hl = "StatusLine", strings = { filename, searchcount } },
            "%=", -- End left alignment
            { hl = "MiniStatuslineDevinfo", strings = { macro } },
            { hl = "StatusLine", strings = { diagnostics } },
            { hl = "StatusLine", strings = { diff } },
        })
    end

    local function content_inactive()
        return "%#MiniStatuslineInactive#%t%="
    end

    statusline.setup({
        content = {
            active = content_active,
            inactive = content_inactive,
        },
    })

    config.new_autocmd({ "RecordingEnter", "RecordingLeave" }, "*", function()
        vim.cmd.redrawstatus()
    end)
end)
