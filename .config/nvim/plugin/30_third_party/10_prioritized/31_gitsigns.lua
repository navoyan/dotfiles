local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("lewis6991/gitsigns.nvim"),
    })

    require("gitsigns").setup({
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]c", function()
                ---@diagnostic disable-next-line: param-type-mismatch
                gitsigns.nav_hunk("next")
            end)

            map("n", "[c", function()
                ---@diagnostic disable-next-line: param-type-mismatch
                gitsigns.nav_hunk("prev")
            end)

            -- Actions
            map("n", "<Leader>hs", gitsigns.stage_hunk)
            map("n", "<Leader>hr", gitsigns.reset_hunk)
            map("v", "<Leader>hs", function()
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end)
            map("v", "<Leader>hr", function()
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end)
            map("n", "<Leader>hS", gitsigns.stage_buffer)
            map("n", "<Leader>hR", gitsigns.reset_buffer)
            map("n", "<Leader>hp", gitsigns.preview_hunk)
            map("n", "<Leader>hi", gitsigns.preview_hunk_inline)
            map("n", "<Leader>hb", function()
                gitsigns.blame_line({ full = true })
            end)
            map("n", "<Leader>tb", gitsigns.toggle_current_line_blame)
            map("n", "<Leader>hd", gitsigns.diffthis)
            map("n", "<Leader>hD", function()
                ---@diagnostic disable-next-line: param-type-mismatch
                gitsigns.diffthis("~")
            end)
            map("n", "<Leader>tw", gitsigns.toggle_word_diff)

            -- Text object
            map({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<CR>")
        end,
        status_formatter = function(status)
            local added, changed, removed = status.added, status.changed, status.removed
            local status_txt = {}
            if added and added > 0 then
                table.insert(status_txt, "%#GitSignsAdd#" .. "+" .. added)
            end
            if changed and changed > 0 then
                table.insert(status_txt, "%#GitSignsChange#" .. "~" .. changed)
            end
            if removed and removed > 0 then
                table.insert(status_txt, "%#GitSignsDelete#" .. "-" .. removed)
            end
            return table.concat(status_txt, " ")
        end,
    })
end)
