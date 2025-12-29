local M = {}

--- @param repo string
--- @return string
function M.github(repo)
    return "https://github.com/" .. repo
end

--- @param repo string
--- @return string
function M.codeberg(repo)
    return "https://codeberg.org/" .. repo
end

--- @return boolean
function M.is_multicursor_mode()
    return package.loaded["multicursor-nvim"] and require("multicursor-nvim").hasCursors()
end

--- @return boolean
function M.is_hydra_mode()
    return package.loaded["hydra"] and require("hydra.statusline").is_active()
end

local global_augroup = vim.api.nvim_create_augroup("config-global", {})

--- @param event vim.api.keyset.events|vim.api.keyset.events[]
--- @param pattern? string|string[]
--- @param callback fun(args: vim.api.keyset.create_autocmd.callback_args): boolean?
function M.new_autocmd(event, pattern, callback)
    local opts = {
        group = global_augroup,
        pattern = pattern,
        callback = callback,
    }
    vim.api.nvim_create_autocmd(event, opts)
end

--- @param plugin_name string
--- @param kinds ("install"|"update"|"delete")[]
--- @param callback fun()
function M.on_packchanged(plugin_name, kinds, callback)
    local function f(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
            return
        end
        if not ev.data.active then
            vim.cmd.packadd(plugin_name)
        end
        callback()
    end
    M.new_autocmd("PackChanged", "*", f)
end

return M
