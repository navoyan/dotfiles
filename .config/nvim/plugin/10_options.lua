vim.g.have_nerd_font = true

if vim.fn.executable("nvr") then
    vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end

vim.diagnostic.config({ virtual_text = true }) -- Use virtual text for diagnostics

require("vim._extui").enable({ -- Replace message grid with experimental UI
    msg = {
        target = "msg",
        timeout = 5000, -- Time a message is visible in the message window.
    },
})

local opt = vim.opt

opt.cmdheight = 0 -- Don't show command line unless it is used
opt.showmode = false -- Don't show mode in command line
opt.showcmd = false -- Don't show (partial) command in command line
opt.pumheight = 10 -- Maximum number of items to show in the (command line) completions menu

opt.inccommand = "split" -- Show partial off-screen `:substitute` results in a preview window

opt.fillchars:append({ diff = "╱" }) -- Replace character for visualizing deleted lines in diff-mode
opt.foldtext = "" -- Display the folded line with regular (treesitter) highlighting
