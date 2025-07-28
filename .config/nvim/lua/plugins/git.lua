return {
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation

                -- Actions
                map("n", "<leader>hs", gitsigns.stage_hunk)
                map("n", "<leader>hr", gitsigns.reset_hunk)
                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                map("n", "<leader>hS", gitsigns.stage_buffer)
                map("n", "<leader>hR", gitsigns.reset_buffer)
                map("n", "<leader>hp", gitsigns.preview_hunk)
                map("n", "<leader>hi", gitsigns.preview_hunk_inline)
                map("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end)
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
                map("n", "<leader>hd", gitsigns.diffthis)
                map("n", "<leader>hD", function()
                    gitsigns.diffthis("~")
                end)
                map("n", "<leader>tw", gitsigns.toggle_word_diff)

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
        },
    },
    {
        "folke/snacks.nvim",
        version = "*",
        lazy = false,
        keys = {
            {
                "<leader>gg",
                function()
                    Snacks.lazygit.open()
                end,
            },
        },
        opts = {
            ---@type snacks.lazygit.Config
            lazygit = {
                config = {
                    os = nil,
                },
                ---@type snacks.win.Config
                win = {
                    width = 0,
                    height = 0,
                    wo = {
                        winhighlight = "Normal:SnacksNormal"
                            .. ",NormalNC:SnacksNormalNC"
                            .. ",WinBar:SnacksWinBar"
                            .. ",WinBarNC:SnacksWinBarNC"
                            -- custom hl
                            .. ",NormalFloat:SnacksLazygitNormal",
                    },
                },
            },
        },
    },
    {
        "sindrets/diffview.nvim",
        dependencies = { "echasnovski/mini.icons" },
        lazy = true,
        cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewLog" },
        config = function()
            local function close_even_last_tab()
                local success = pcall(vim.cmd.tabclose)
                if not success then
                    vim.cmd.quitall()
                end
            end

            require("diffview").setup({
                keymaps = {
                    view = {
                        ["q"] = close_even_last_tab,
                    },
                    file_panel = {
                        ["q"] = close_even_last_tab,
                    },
                    file_history_panel = {
                        ["q"] = close_even_last_tab,
                    },
                },
                hooks = {
                    view_opened = function(view)
                        if view.commit_log_panel then
                            local opts = { desc = "Close commit log panel", buffer = view.commit_log_panel.bufid }

                            vim.keymap.set("n", "q", function()
                                view.commit_log_panel:close()
                            end, opts)
                        end
                    end,
                },
            })
        end,
    },
    {
        "folke/snacks.nvim",
        version = "*",
        lazy = false,
        keys = {
            {
                "<leader>go",
                function()
                    Snacks.gitbrowse.open()
                end,
            },
            {
                "<leader>gb",
                function()
                    Snacks.gitbrowse.open({ what = "branch" })
                end,
            },
        },
        opts = {
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
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim", -- Diff integration
        },
        config = true,
        keys = {
            {
                "<leader>G",
                function()
                    require("neogit").open()
                end,
                desc = "Open Neogit",
            },
        },
    },
    {
        "tpope/vim-fugitive",
    },
}
