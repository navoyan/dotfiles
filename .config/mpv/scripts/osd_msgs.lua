mp.observe_property("volume", "number", function(_, val)
    if val ~= nil then
        mp.osd_message("Volume: " .. val .. "%", 1.5)
    end
end)

mp.observe_property("mute", "bool", function(_, val)
    if val ~= nil then
        mp.osd_message("Mute: " .. (val and "yes" or "no"), 1.5)
    end
end)

mp.observe_property("sub-visibility", "bool", function(_, val)
    if val ~= nil then
        mp.osd_message("Subtitles: " .. (val and "visible" or "hidden"), 1.5)
    end
end)
