vim.g.have_nerd_font = true

vim.diagnostic.config({ virtual_text = true })

local opt = vim.opt

opt.inccommand = "split"

opt.fillchars:append({ diff = "╱" })
