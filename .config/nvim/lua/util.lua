_G.Util = {}

local keycodes = {}

function Util.keycode(key)
    if not keycodes[key] then
        keycodes[key] = vim.api.nvim_replace_termcodes(key, true, true, true)
    end

    return keycodes[key]
end

function Util.is_multicursor_mode()
    return package.loaded["multicursor-nvim"] and require("multicursor-nvim").hasCursors()
end
