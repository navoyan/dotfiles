local mp = require("mp")
local utils = require("mp.utils")

mp.register_event("file-loaded", function()
    local path = mp.get_property("path")
    if not path then
        return
    end

    local dir = utils.split_path(path)
    local dir_name = dir:match("([^/]+)/*$")

    if dir_name then
        mp.set_property("screenshot-directory", "~/Pictures/MPV Screenshots/" .. dir_name)
    end
end)
