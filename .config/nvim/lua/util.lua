_G.Util = {}

function Util.is_multicursor_mode()
    return package.loaded["multicursor-nvim"] and require("multicursor-nvim").hasCursors()
end
