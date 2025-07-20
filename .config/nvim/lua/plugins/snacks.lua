return {
    "folke/snacks.nvim",
    version = "*",
    priority = 1000,
    lazy = false,
    config = function(_, opts)
        require("snacks").setup(opts)

        local is_cwd_dotfiles = vim.fn.getcwd() == vim.env.HOME .. "/dotfiles"
        local show_hidden_for_dotfiles = is_cwd_dotfiles and { hidden = true } or {}

        local inline_preview = { layout = { preset = "vscode", preview = "main" } }

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

        map("n", "<leader>gg", Snacks.lazygit.open)

        map({ "n", "v" }, "<leader>go", Snacks.gitbrowse.open)
        map("n", "<leader>gb", function()
            Snacks.gitbrowse.open({ what = "branch" })
        end)

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

        map("n", "<leader>dd", conf(Snacks.picker.diagnostics_buffer, inline_preview))
        map("n", "<leader>dD", conf(Snacks.picker.diagnostics_buffer, inline_preview, severity(vim_severity.ERROR)))
        map("n", "<leader>dw", conf(Snacks.picker.diagnostics, inline_preview))
        map("n", "<leader>dW", conf(Snacks.picker.diagnostics, inline_preview, severity(vim_severity.ERROR)))

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
    opts = {
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
        },
        image = {},
        words = {
            debounce = 10,
        },
        indent = {
            animate = {
                enabled = false,
            },
            scope = {
                enabled = false,
            },
        },
        dashboard = {
            sections = {
                { section = "header" },
                { section = "startup" },
            },
        },
        lazygit = {
            config = {
                os = {
                    edit = '[ -z "[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})',
                    editAtLine = ': `[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" &&  nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>")',
                    editAtLineAndWait = "nvim +{{line}} {{filename}}",
                    openDirInEditor = '[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{dir}})',
                },
            },
        },
        bigfile = {},
        quickfile = {},
        gitbrowse = {
            remote_patterns = {
                { "^ssh://git@git%.(.+):(.+)/main/(.+)%.git$", "https://space.%1:%2/p/main/repositories/%3" },
                { "^(https?://.*)%.git$", "%1" },
                { "^git@(.+):(.+)%.git$", "https://%1/%2" },
                { "^git@(.+):(.+)$", "https://%1/%2" },
                { "^git@(.+)/(.+)$", "https://%1/%2" },
                { "^ssh://git@(.*)$", "https://%1" },
                { "^ssh://([^:/]+)(:%d+)/(.*)$", "https://%1/%3" },
                { "^ssh://([^/]+)/(.*)$", "https://%1/%2" },
                { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
                { "^https://%w*@(.*)", "https://%1" },
                { "^git@(.*)", "https://%1" },
                { ":%d+", "" },
                { "%.git$", "" },
            },
            url_patterns = {
                ["space%.(.+)"] = {
                    branch = "/commits?query=head:refs/heads/{branch}&tab=changes",
                    file = function(fields)
                        return "/files/dev/"
                            .. fields.file
                            .. "?tab=source&line="
                            .. fields.line_start
                            .. "&lines-count="
                            .. fields.line_end - fields.line_start + 1
                    end,
                    commit = "/revision/{commit}",
                },
                ["github%.com"] = {
                    branch = "/tree/{branch}",
                    file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
                    commit = "/commit/{commit}",
                },
                ["gitlab%.com"] = {
                    branch = "/-/tree/{branch}",
                    file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
                    commit = "/-/commit/{commit}",
                },
            },
        },
    },
}
