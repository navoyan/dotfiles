return {
    "folke/snacks.nvim",
    version = "*",
    priority = 1000,
    lazy = false,
    config = function(_, opts)
        require("snacks").setup(opts)

        local function show_hidden_for_dotfiles(picker_fn)
            return function()
                if vim.fn.getcwd() ~= vim.env.HOME .. "/dotfiles" then
                    picker_fn()
                else
                    picker_fn({ hidden = true })
                end
            end
        end

        local function with_inline_preview(picker_fn)
            return function()
                picker_fn({ layout = { preset = "vscode", preview = "main" } })
            end
        end

        local map = vim.keymap.set

        map("n", "<leader>gg", Snacks.lazygit.open)

        map({ "n", "v" }, "<leader>go", Snacks.gitbrowse.open)
        map("n", "<leader>gb", function()
            Snacks.gitbrowse.open({ what = "branch" })
        end)

        map("n", "<leader>sp", Snacks.picker.resume)

        map("n", "<leader>ff", show_hidden_for_dotfiles(Snacks.picker.files))
        map("n", "<leader>fo", Snacks.picker.buffers)
        map("n", "<leader>fg", Snacks.picker.git_status)
        map("n", "<leader>fp", Snacks.picker.projects)

        map("n", "<leader>sf", show_hidden_for_dotfiles(Snacks.picker.grep))
        map("n", "<leader>so", Snacks.picker.grep_buffers)
        map("n", "<leader>sg", Snacks.picker.git_grep)
        map({ "n", "x" }, "<leader>sc", show_hidden_for_dotfiles(Snacks.picker.grep_word))

        map("n", "<leader>ss", Snacks.picker.lines)

        map("n", "<leader>dd", with_inline_preview(Snacks.picker.diagnostics_buffer))
        map("n", "<leader>dw", with_inline_preview(Snacks.picker.diagnostics))

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

        local function pick_colorschemes()
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
                                        ["<C-Bs>"] = { "flash", mode = { "n", "i" } },
                                        ["<Bs>"] = { "flash" },
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
