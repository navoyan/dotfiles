local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.now_if_args(function()
    vim.pack.add({
        config.github("nvim-mini/mini.files"),
    })

    local files = require("mini.files")

    files.setup({
        options = {
            -- Whether to delete permanently or move into module-specific trash
            permanent_delete = false,
            -- Whether to use for editing directories
            use_as_default_explorer = true,
        },
        mappings = {
            close = "q",
            go_in = "l",
            go_in_plus = "<Enter>",
            go_out = "h",
            go_out_plus = "H",
            reset = "=",
            reveal_cwd = "@",
            show_help = "g?",
            synchronize = "Q",
            trim_left = "<",
            trim_right = ">",
        },
        windows = {
            -- Maximum number of windows to show side by side
            max_number = math.huge,
            -- Width of focused window
            width_focus = 50,
            -- Width of non-focused window
            width_nofocus = 20,
            -- Whether to show preview of file/directory under cursor
            preview = true,
            -- Width of preview window
            width_preview = 50,
        },
    })

    config.new_autocmd("User", "MiniFilesWindowOpen", function(args)
        local win_id = args.data.win_id

        vim.wo[win_id].cursorlineopt = "line"
    end)

    map("n", "<Leader>e", function()
        local path = vim.api.nvim_buf_get_name(0)
        if vim.uv.fs_stat(path) then
            files.open(path)
        else
            files.open(vim.fs.dirname(path))
        end
        files.reveal_cwd()
    end)
end)
