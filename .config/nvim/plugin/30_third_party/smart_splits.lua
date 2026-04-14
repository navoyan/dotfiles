local schedule, config, notify = require("schedule"), require("config"), require("notify")
local map = vim.keymap.set

schedule.later(function()
    config.on_packchanged("smart-splits.nvim", { "install", "update" }, function(ev)
        local plugin_path = ev.data.path

        vim.system(
            { "./kitty/install-kittens.bash" },
            { cwd = plugin_path },
            vim.schedule_wrap(function(result)
                local code = result.code
                if code ~= 0 then
                    notify.error("`install-kittens` for `smart-splits` exited with code " .. code)
                end
            end)
        )
    end)

    vim.pack.add({
        config.github("mrjones2014/smart-splits.nvim"),
    })

    local splits = require("smart-splits")

    -- moving between splits
    map("n", "<M-h>", splits.move_cursor_left)
    map("n", "<M-j>", splits.move_cursor_down)
    map("n", "<M-k>", splits.move_cursor_up)
    map("n", "<M-l>", splits.move_cursor_right)
    -- resizing splits
    map("n", "<M-C-h>", splits.resize_left)
    map("n", "<M-C-j>", splits.resize_down)
    map("n", "<M-C-k>", splits.resize_up)
    map("n", "<M-C-l>", splits.resize_right)
    -- swapping buffers between windows
    map("n", "<M-Left>", splits.swap_buf_left)
    map("n", "<M-Down>", splits.swap_buf_down)
    map("n", "<M-Up>", splits.swap_buf_up)
    map("n", "<M-Right>", splits.swap_buf_right)
end)
