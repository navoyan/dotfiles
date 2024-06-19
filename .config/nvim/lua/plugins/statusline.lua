return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "letieu/harpoon-lualine",
    },
    opts = {
        options = {
            theme = "catppuccin",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { "mode" },
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
            lualine_x = {
                {
                    "harpoon2",
                    indicators = { "A", "S", "Q", "W" },
                    active_indicators = { "[A]", "[S]", "[Q]", "[W]" },
                },
            },
            lualine_y = {
                "diagnostics",
            },
            lualine_z = {},
        },
    },
}
