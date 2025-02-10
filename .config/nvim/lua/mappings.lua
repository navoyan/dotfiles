vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<leader>l", function()
    vim.api.nvim_command("silent update")
end, { desc = "Save" })
