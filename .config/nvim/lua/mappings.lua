vim.keymap.set("n", "<leader>l", function()
    vim.api.nvim_command("silent wall")
end, { desc = "Save" })

-- Function to save jump and perform motion
local function save_jump(motion)
    local augroup_exists = pcall(vim.api.nvim_del_augroup_by_name, "SaveJump")
    if not augroup_exists then
        vim.cmd("normal! m'")
    end

    local counted_motion = motion
    local count = vim.v.count
    if count > 0 then
        counted_motion = count .. motion
    end

    local motion_termcodes = vim.api.nvim_replace_termcodes(counted_motion, true, true, true)
    vim.api.nvim_feedkeys(motion_termcodes, "n", false)

    local augroup = vim.api.nvim_create_augroup("SaveJump", { clear = true })
    local tracked_jump = false
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = augroup,
        callback = function()
            if tracked_jump then
                vim.api.nvim_del_augroup_by_name("SaveJump")
            else
                tracked_jump = true
            end
        end,
    })
end

vim.keymap.set("n", "<C-j>", function()
    save_jump("<C-d>")
    vim.cmd("normal! zz")
end, { silent = true, remap = true })

vim.keymap.set("n", "<C-k>", function()
    save_jump("<C-u>")
    vim.cmd("normal! zz")
end, { silent = true, remap = true })
