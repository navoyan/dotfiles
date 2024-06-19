return {
    {
        "echasnovski/mini.files",
        version = "*",
        lazy = false,
        keys = {
            {
                "<leader>e",
                function()
                    local current_buf = vim.api.nvim_buf_get_name(0)
                    MiniFiles.open(current_buf)
                    MiniFiles.reveal_cwd()
                end,
                desc = "Open MiniFiles",
            },
        },
        opts = {
            options = {
                -- Whether to delete permanently or move into module-specific trash
                permanent_delete = false,
                -- Whether to use for editing directories
                use_as_default_explorer = true,
            },
            mappings = {
                close = "q",
                go_in = "l",
                go_in_plus = "L",
                go_out = "h",
                go_out_plus = "H",
                reset = "<BS>",
                reveal_cwd = "@",
                show_help = "g?",
                synchronize = "Q",
                trim_left = "<",
                trim_right = ">",
            },
            windows = {
                -- Maximum number of windows to show side by side
                max_number = math.huge,
                -- Whether to show preview of file/directory under cursor
                preview = true,
                -- Width of focused window
                width_focus = 50,
                -- Width of non-focused window
                width_nofocus = 15,
                -- Width of preview window
                width_preview = 25,
            },
        },
    },
}
