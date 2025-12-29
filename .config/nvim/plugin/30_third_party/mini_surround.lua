local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("nvim-mini/mini.surround"),
    })

    require("mini.surround").setup({
        mappings = {
            update_n_lines = "", -- Update `n_lines`
        },
    })
end)
