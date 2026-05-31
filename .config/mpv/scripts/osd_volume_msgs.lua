mp.observe_property("volume", "number", function(_, val)
    if val == nil then
        return
    end
    mp.osd_message(string.format("Volume: %d%%", val), 1.5)
end)

mp.observe_property("mute", "bool", function(_, val)
    if val == nil then
        return
    end
    mp.osd_message(val and "Mute: yes" or "Mute: no", 1.5)
end)
