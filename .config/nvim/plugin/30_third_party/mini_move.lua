local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("nvim-mini/mini.move"),
    })

    require("mini.move").setup({
        mappings = {
            -- Move visual selection in Visual mode
            left = "<C-S-h>",
            right = "<C-S-l>",
            down = "<C-S-j>",
            up = "<C-S-k>",

            -- Cove current line in Normal mode
            line_left = "<C-S-h>",
            line_right = "<C-S-l>",
            line_down = "<C-S-j>",
            line_up = "<C-S-k>",
        },
    })
end)
