return {
    {
        "folke/snacks.nvim",
        version = "*",
        lazy = false,
        opts = {
            ---@type snacks.picker.Config
            picker = {
                matcher = {
                    frecency = true,
                },
                formatters = {
                    file = {
                        filename_first = true,
                        truncate = 60,
                    },
                },
                debug = {
                    scores = false,
                },
                layouts = {
                    default = {
                        layout = {
                            box = "horizontal",
                            width = 0.8,
                            min_width = 120,
                            height = 0.8,
                            {
                                box = "vertical",
                                width = 0.45,
                                {
                                    win = "input",
                                    height = 1,
                                    title = "{title} {live} {flags}",
                                    border = "single",
                                },
                                { win = "list", border = "none" },
                            },
                            {
                                win = "preview",
                                -- there is no statuscolumn gap in minimal style
                                style = "minimal",
                                title = "{preview}",
                                border = "single",
                                width = 0.55,
                            },
                        },
                    },
                    inline_preview = {
                        preview = "main",
                        layout = {
                            backdrop = false,
                            row = 1,
                            width = 0.4,
                            min_width = 80,
                            height = 0.4,
                            border = "none",
                            box = "vertical",
                            {
                                win = "input",
                                height = 1,
                                border = "single",
                                title = "{title} {live} {flags}",
                                title_pos = "center",
                            },
                            { win = "list", border = "hpad" },
                            { win = "preview", title = "{preview}", border = "single" },
                        },
                    },
                    select = {
                        layout = {
                            backdrop = false,
                            width = 0.4,
                            min_width = 80,
                            height = 0.4,
                            min_height = 3,
                            box = "vertical",
                            border = "single",
                            title = "{title}",
                            title_pos = "center",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", border = "none" },
                            { win = "preview", title = "{preview}", height = 0.4, border = "top" },
                        },
                    },
                    vertical = {
                        layout = {
                            backdrop = false,
                            width = 0.5,
                            min_width = 80,
                            height = 0.8,
                            min_height = 30,
                            box = "vertical",
                            border = "single",
                            title = "{title} {live} {flags}",
                            title_pos = "center",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", border = "none" },
                            { win = "preview", style = "minimal", title = "{preview}", height = 0.4, border = "top" },
                        },
                    },
                    code_action = {
                        layout = {
                            backdrop = false,
                            width = 0.6,
                            min_width = 80,
                            height = 0.6,
                            min_height = 30,
                            box = "vertical",
                            border = "single",
                            title = "{title}",
                            title_pos = "center",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", height = 0.2, border = "none" },
                            { win = "preview", title = "{preview}", border = "top" },
                        },
                    },
                },
                sources = {
                    diagnostics_buffer = { layout = "inline_preview" },
                    diagnostics = { layout = "inline_preview" },
                    lsp_definitions = { layout = "inline_preview" },
                    lsp_references = { layout = "inline_preview" },
                    lsp_implementations = { layout = "inline_preview" },
                    lsp_type_definitions = { layout = "inline_preview" },
                    lsp_symbols = { layout = "inline_preview" },
                    lsp_workspace_symbols = { layout = "inline_preview" },
                },
            },
        },
        config = function(_, opts)
            require("snacks").setup(opts)

            local is_cwd_dotfiles = vim.fn.getcwd() == vim.env.HOME .. "/dotfiles"
            local show_hidden_for_dotfiles = is_cwd_dotfiles and { hidden = true } or {}

            local function conf(picker_fn, ...)
                local result_config = {}
                for _, config in ipairs({ ... }) do
                    result_config = vim.tbl_deep_extend("error", result_config, config)
                end

                return function()
                    picker_fn(result_config)
                end
            end

            local map = vim.keymap.set

            map("n", "<leader>sp", Snacks.picker.resume)

            map("n", "<leader>ff", conf(Snacks.picker.files, show_hidden_for_dotfiles))
            map("n", "<leader>fo", Snacks.picker.buffers)
            map("n", "<leader>fg", Snacks.picker.git_status)
            map("n", "<leader>fp", Snacks.picker.projects)

            map("n", "<leader>sf", conf(Snacks.picker.grep, show_hidden_for_dotfiles))
            map("n", "<leader>so", Snacks.picker.grep_buffers)
            map("n", "<leader>sg", Snacks.picker.git_grep)
            map({ "n", "x" }, "<leader>sc", conf(Snacks.picker.grep_word, show_hidden_for_dotfiles))

            map("n", "<leader>ss", Snacks.picker.lines)

            local vim_severity = vim.diagnostic.severity
            local function severity(picker_severity)
                return { severity = picker_severity }
            end

            map("n", "<leader>dd", Snacks.picker.diagnostics_buffer)
            map("n", "<leader>dD", conf(Snacks.picker.diagnostics_buffer, severity(vim_severity.ERROR)))
            map("n", "<leader>dw", Snacks.picker.diagnostics)
            map("n", "<leader>dW", conf(Snacks.picker.diagnostics, severity(vim_severity.ERROR)))

            map("n", "<leader>su", Snacks.picker.undo)
            map("n", "<leader>sq", Snacks.picker.qflist)

            map("n", "<leader>sH", Snacks.picker.help)
            map("n", "<leader>sC", Snacks.picker.commands)
            map("n", "<leader>sK", Snacks.picker.keymaps)
            map("n", "<leader>sM", Snacks.picker.man)

            local function command_history()
                local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
                vim.api.nvim_feedkeys(esc, "c", true)

                vim.defer_fn(function()
                    Snacks.picker.command_history()
                end, 1)
            end

            map("c", "<C-r>", command_history)

            local function confirm_colorscheme(picker, item)
                picker:close()
                if not item then
                    return
                end

                picker.preview.state.colorscheme = nil
                vim.schedule(function()
                    local theme = item.text
                    vim.cmd.colorscheme(theme)

                    local current_theme_path = vim.fn.stdpath("config") .. "/lua/current_theme.lua"
                    vim.uv.fs_open(current_theme_path, "w", 432, function(err, fd)
                        if err then
                            Snacks.notify.error("Failed to open `" .. theme .. "`:\n- " .. err)
                            return
                        end

                        vim.loop.fs_write(fd, 'vim.cmd.colorscheme("' .. theme .. '")', nil, function()
                            vim.loop.fs_close(fd)
                        end)
                    end)
                end)
            end

            local function pick_colorschemes()
                Snacks.picker.colorschemes({
                    confirm = confirm_colorscheme,
                })
            end

            map("n", "<leader>sT", pick_colorschemes)
        end,
    },
    {
        "MagicDuck/grug-far.nvim",
        opts = {},
        keys = {
            {
                "<leader>sr",
                function()
                    local grug = require("grug-far")
                    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                    grug.open({
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        },
                    })
                end,
                mode = { "n", "v" },
                desc = "[S]earch and [R]eplace",
            },
        },
    },
}
