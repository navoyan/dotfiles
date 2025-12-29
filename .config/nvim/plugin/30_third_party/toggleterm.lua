local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        {
            src = config.github("akinsho/toggleterm.nvim"),
            version = vim.version.range("*"),
        },
    })

    require("toggleterm").setup()

    local Terminal = require("toggleterm.terminal").Terminal

    local lazygit = Terminal:new({
        cmd = "lazygit",
        direction = "tab",
        highlights = {
            Normal = {
                link = "LazygitNormal",
            },
        },
        on_open = function(term)
            -- Handle the case when lazygit executes `DiffViewOpen` via nvim-remote
            -- and then regains focus when closing the diff view
            local enter_augroup = vim.api.nvim_create_augroup("LazygitEnter", { clear = true })
            vim.api.nvim_create_autocmd("BufEnter", {
                group = enter_augroup,
                buffer = term.bufnr,
                callback = vim.schedule_wrap(function()
                    vim.cmd.startinsert()
                end),
            })
        end,
    })

    map("n", "<Leader>gg", function()
        lazygit:toggle()
    end)
end)
