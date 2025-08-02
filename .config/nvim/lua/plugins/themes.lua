return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
            on_highlights = function(h, c)
                h.CursorLineNr = { fg = c.border_highlight, bold = true }

                h.Folded = { fg = h.Folded.fg, bg = "#2d3249" }

                h.DiffDeleteText = { bg = "#713137" }
                h.DiffAddText = { bg = "#2c5a66" }

                -- HACK: fixes `live-rename.nvim` highlighting
                h.Normal = { fg = c.fg, bg = c.bg }

                h.SnacksLazygitNormal = { bg = c.none }

                h.LeapBackdrop = nil
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
            end,
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        enabled = false,
        priority = 1000,
        opts = {
            flavour = "mocha",
            integrations = {
                cmp = true,
                treesitter = true,
                mini = {
                    enabled = true,
                },
                neogit = true,
            },
        },
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        enabled = false,
        lazy = true,
        priority = 1000,
        opts = {},
    },
}
