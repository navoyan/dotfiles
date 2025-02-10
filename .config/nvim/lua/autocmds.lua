vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("autosave", { clear = true }),
    callback = function()
        if
            vim.bo.modified
            and not vim.bo.readonly
            and vim.fn.expand("%") ~= ""
            and vim.bo.buftype == ""
            and vim.bo.filetype ~= "lua"
        then
            vim.api.nvim_command("silent update")
        end
    end,
})
