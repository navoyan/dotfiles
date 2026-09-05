local misc = require("mini.misc")

local M = {}

M.now = function(f)
    misc.safely("now", f)
end

M.later = function(f)
    misc.safely("later", f)
end

M.now_if_args = vim.fn.argc(-1) > 0 and M.now or M.later

M.on_event = function(ev, f)
    misc.safely("event:" .. ev, f)
end

M.on_filetype = function(ft, f)
    misc.safely("filetype:" .. ft, f)
end

return M
