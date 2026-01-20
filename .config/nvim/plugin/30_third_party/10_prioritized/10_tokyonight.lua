local schedule, config = require("schedule"), require("config")

schedule.now(function()
    vim.pack.add({
        config.github("folke/tokyonight.nvim"),
    })

    require("tokyonight").setup({
        transparent = true,
        on_colors = function() end,
        on_highlights = function(h, c)
            local util = require("tokyonight.util")

            h.CursorLineNr = { fg = c.border_highlight, bold = true }

            h.Folded = { fg = h.Folded.fg, bg = util.blend_bg(h.Folded.bg, 0.3) }

            h.DiffDeleteText = { bg = "#713137" }
            h.DiffAddText = { bg = "#2c5a66" }

            -- HACK: fixes `live-rename.nvim` highlighting
            h.Normal = { fg = c.fg, bg = c.bg }

            for _, mode in ipairs({ "Normal", "Insert", "Visual", "Replace", "Command", "Other" }) do
                h["MiniStatuslineMode" .. mode].bold = false
            end
            h.MiniStatuslineBranch = { bg = c.fg_gutter, fg = c.blue }
            h.MiniStatuslineInactive = { fg = c.dark3 }

            h.LazygitNormal = { bg = c.none }

            h.LeapLabel = { bg = c.magenta2, fg = c.fg, bold = true }

            h.TreesitterContext = { link = "NormalFloat" }

            -- original: hl-SnacksPickerInputTitle
            h.FloatTitleFocused = {
                bg = "#16161E",
                fg = "#FF9E64",
                bold = true,
            }

            h.SnacksPickerInputTitle = { link = "FloatTitleFocused" }
            h.SnacksPickerBoxTitle = { link = "FloatTitleFocused" }
            h.SnacksPickerPreviewTitle = { link = "FloatTitleFocused" }

            h.SnacksPickerInputBorder = { link = "FloatBorder" }
        end,
    })

    vim.cmd.colorscheme("tokyonight-night")
end)
