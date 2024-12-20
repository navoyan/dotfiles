vim.opt_local.modifiable = false
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

vim.api.nvim_create_autocmd({ "FocusLost" }, {
    buffer = 0,
    command = "quit",
})
