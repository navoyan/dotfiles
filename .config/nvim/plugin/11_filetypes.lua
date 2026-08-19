local config = require("config")

vim.filetype.add({
    extension = {
        gotmpl = "gotmpl",
    },
    pattern = {
        [".*/templates/.*%.tpl"] = "helm",
        [".*/templates/.*%.ya?ml"] = "helm",
        ["helmfile.*%.ya?ml"] = "helm",
    },
})

-- NOT a glob, matches nested directories as well:
local mpv_conf_pattern = vim.env.HOME .. "/{dotfiles/,}.config/mpv/*.conf"
config.new_autocmd({ "BufNewFile", "BufRead" }, mpv_conf_pattern, function()
    vim.bo.filetype = "confini"
    vim.schedule(function()
        vim.bo.commentstring = "# %s"
    end)
end)
