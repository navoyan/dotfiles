local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("sindrets/diffview.nvim"),
    })

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
                ---@type CommitLogPanel
                local commit_log_panel = view.commit_log_panel

                commit_log_panel:on_autocmd("BufWinEnter", {
                    callback = function(args)
                        local opts = { buffer = args.buf }
                        local close = function()
                            commit_log_panel:close()
                        end

                        map("n", "q", close, opts)
                        map("n", "<Esc>", close, opts)
                    end,
                })
            end,
            diff_buf_win_enter = function(_, _, ctx)
                -- Highlight 'DiffChange' as 'DiffDelete' on the left,
                -- and 'DiffAdd' on the right.
                if ctx.layout_name:match("^diff2") then
                    if ctx.symbol == "a" then
                        vim.opt_local.winhl = table.concat({
                            "DiffAdd:DiffDelete",
                            "DiffChange:DiffDelete",
                            "DiffText:DiffDeleteText",
                        }, ",")
                    elseif ctx.symbol == "b" then
                        vim.opt_local.winhl = table.concat({
                            "DiffChange:DiffAdd",
                            "DiffText:DiffAddText",
                        }, ",")
                    end
                end
            end,
        },
    })
end)
