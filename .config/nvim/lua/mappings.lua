_G.Mappings = {}

local map = vim.keymap.set

map("n", "<leader>w", function()
    vim.api.nvim_command("silent wall")
end, { desc = "[W]rite all" })

map("n", "g/", "/\\%V", { silent = false, desc = "Search inside last visual selection" })
map("x", "g/", "<Esc>/\\%V", { silent = false, desc = "Search inside visual selection" })

-- Put empty line and jump to it. Supports dot-repeat
function Mappings.put_empty_line(put_above)
    if type(put_above) == "boolean" then
        vim.o.operatorfunc = "v:lua.Mappings.put_empty_line"
        Mappings.cache_empty_line = { put_above = put_above }
        return "g@l"
    end

    local above = Mappings.cache_empty_line.put_above

    local target_line = vim.fn.line(".") - (above and 1 or 0)
    vim.fn.append(target_line, vim.fn["repeat"]({ "" }, vim.v.count1))

    vim.cmd("normal! " .. (above and "k" or "j"))
end

map("n", "gO", "v:lua.Mappings.put_empty_line(v:true)", { expr = true, desc = "Put empty line above" })
map("n", "go", "v:lua.Mappings.put_empty_line(v:false)", { expr = true, desc = "Put empty line below" })

-- Save current location into jumplist and perform motion.
-- Do not save the jump again until cursor is moved because of other motion
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

    vim.cmd("normal! " .. counted_motion)

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

local down_motion = Util.keycode("<C-d>")
map("n", "<C-j>", function()
    save_jump(down_motion)
    vim.cmd("normal! zz")
end, { silent = true })

local up_motion = Util.keycode("<C-u>")
map("n", "<C-k>", function()
    save_jump(up_motion)
    vim.cmd("normal! zz")
end, { silent = true })
