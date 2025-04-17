return {
    "folke/snacks.nvim",
    version = "*",
    priority = 1000,
    lazy = false,
    keys = {
        {
            "<leader>gg",
            function()
                Snacks.lazygit()
            end,
        },
        {
            "<leader>go",
            function()
                Snacks.gitbrowse()
            end,
            mode = { "n", "v" },
        },
        {
            "<leader>gb",
            function()
                Snacks.gitbrowse({ what = "branch" })
            end,
        },
        {
            "<leader>sp",
            function()
                Snacks.picker.resume()
            end,
        },
        {
            "<leader>ff",
            function()
                if vim.fn.getcwd() ~= vim.env.HOME .. "/dotfiles" then
                    Snacks.picker.files()
                else
                    Snacks.picker.files({ hidden = true })
                end
            end,
        },
        {
            "<leader>fo",
            function()
                Snacks.picker.buffers()
            end,
        },
        {
            "<leader>fg",
            function()
                Snacks.picker.git_status()
            end,
        },
        {
            "<leader>fp",
            function()
                Snacks.picker.projects()
            end,
        },
        {
            "<leader>sf",
            function()
                Snacks.picker.grep()
            end,
        },
        {
            "<leader>so",
            function()
                Snacks.picker.grep_buffers()
            end,
        },
        {
            "<leader>sg",
            function()
                Snacks.picker.git_grep()
            end,
        },
        {
            "<leader>sc",
            function()
                Snacks.picker.grep_word()
            end,
            mode = { "n", "x" },
        },
        {
            "<leader>ss",
            function()
                Snacks.picker.lines()
            end,
        },
        {
            "<leader>su",
            function()
                Snacks.picker.undo()
            end,
        },
        {
            "<leader>dd",
            function()
                Snacks.picker.diagnostics_buffer({ layout = { preset = "vscode", preview = "main" } })
            end,
        },
        {
            "<leader>dw",
            function()
                Snacks.picker.diagnostics({ layout = { preset = "vscode", preview = "main" } })
            end,
        },
        {
            mode = "c",
            "<C-r>",
            function()
                local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
                vim.api.nvim_feedkeys(esc, "c", true)

                vim.defer_fn(function()
                    Snacks.picker.command_history()
                end, 1)
            end,
        },
        {
            "<leader>sq",
            function()
                Snacks.picker.qflist()
            end,
        },
        {
            "<leader>sH",
            function()
                Snacks.picker.help()
            end,
        },
        {
            "<leader>sC",
            function()
                Snacks.picker.commands()
            end,
        },
        {
            "<leader>sK",
            function()
                Snacks.picker.keymaps()
            end,
        },
        {
            "<leader>sM",
            function()
                Snacks.picker.man()
            end,
        },
        {
            "<leader>sT",
            function()
                Snacks.picker.colorschemes({
                    confirm = function(picker, item)
                        picker:close()
                        if item then
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
                    end,
                })
            end,
        },
    },
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
    dependencies = {
        {
            "folke/flash.nvim",
            optional = true,
            specs = {
                {
                    "folke/snacks.nvim",
                    opts = {
                        picker = {
                            win = {
                                input = {
                                    keys = {
                                        ["<a-s>"] = { "flash", mode = { "n", "i" } },
                                        ["s"] = { "flash" },
                                    },
                                },
                            },
                            actions = {
                                flash = function(picker)
                                    require("flash").jump({
                                        pattern = "^",
                                        label = { after = { 0, 0 } },
                                        search = {
                                            mode = "search",
                                            exclude = {
                                                function(win)
                                                    return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
                                                        ~= "snacks_picker_list"
                                                end,
                                            },
                                        },
                                        action = function(match)
                                            local idx = picker.list:row2idx(match.pos[1])
                                            picker.list:_move(idx, true, true)
                                        end,
                                    })
                                end,
                            },
                        },
                    },
                },
            },
        },
    },
}
