local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("saecki/live-rename.nvim"),
    })

    config.new_autocmd("LspAttach", "*", function(event)
        local map = function(keys, func)
            vim.keymap.set("n", keys, func, { buffer = event.buf })
        end

        local function rename_fn(opts)
            return function()
                require("live-rename").rename(opts)

                -- NOTE: needed to disable completions
                vim.bo.filetype = "liverename"
            end
        end

        map("<Leader>rn", rename_fn())
        map("<Leader>ri", rename_fn({ text = "", insert = true }))
    end)
end)
