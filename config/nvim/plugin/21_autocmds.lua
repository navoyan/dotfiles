local config = require("config")

config.new_autocmd("TextYankPost", "*", function()
    return vim.hl.on_yank()
end)
