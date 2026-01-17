local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        { src = config.github("kylechui/nvim-surround"), version = vim.version.range("*") },
    })

    require("nvim-surround").setup({
        keymaps = {
            normal = "sa",
            normal_line = "sA",
            delete = "sd",
            change = "sr",
            change_line = "sR",
            visual = "sa",
            visual_line = "sA",

            insert = false,
            insert_line = false,
            normal_cur = false,
            normal_cur_line = false,
        },
    })
end)
