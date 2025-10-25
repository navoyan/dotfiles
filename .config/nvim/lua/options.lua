vim.g.have_nerd_font = true

if vim.fn.executable("nvr") then
    vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end

vim.diagnostic.config({ virtual_text = true }) -- Use virtual text for diagnostics

local opt = vim.opt

opt.showmode = false -- Don't show mode in command line

opt.inccommand = "split" -- Show partial off-screen `:substitute` results in a preview window

opt.fillchars:append({ diff = "╱" }) -- Replace character for visualizing deleted lines in diff-mode
opt.foldtext = "" -- Display the folded line with regular (treesitter) highlighting

opt.foldmethod = "expr" -- Use 'foldexpr' for folding
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter folding

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end

        if client:supports_method("textDocument/foldingRange") then
            vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()" -- Use LSP folding
        end
    end,
})
