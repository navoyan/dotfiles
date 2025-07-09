return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        options = {
            theme = "tokyonight",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { -- Filetypes to disable lualine for.
                statusline = { "no-neck-pain", "snacks_dashboard" }, -- only ignores the ft for statusline.
                winbar = {}, -- only ignores the ft for winbar.
            },
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    fmt = function(mode)
                        local hydra = require("hydra.statusline")

                        return hydra.is_active() and "HYDRA" or mode
                    end,
                    color = function()
                        local hydra = require("hydra.statusline")
                        local colors = require("tokyonight.colors").setup()

                        return { bg = hydra.is_active() and colors.red or nil }
                    end,
                },
            },
            lualine_b = { "branch", "diff" },
            lualine_c = {
                {
                    "filetype",
                    icon_only = true,
                    padding = { left = 1, right = 0 },
                    separator = "",
                },
                {
                    "filename",
                    path = 1,
                    padding = 0,
                },
            },
            lualine_x = {},
            lualine_y = {
                "diagnostics",
            },
            lualine_z = {},
        },
    },
}
