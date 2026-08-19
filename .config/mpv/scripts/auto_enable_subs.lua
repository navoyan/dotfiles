local msg = require("mp.msg")

local function detect_lang_and_run(title, callback)
    mp.command_native_async({
        name = "subprocess",
        args = {
            "rust-script",
            "/home/narek/.config/mpv/detect_lang.rs",
            title,
        },
        capture_stdout = true,
        playback_only = false,
    }, function(success, res, err)
        if success and res.status == 0 then
            callback(res.stdout)
        else
            local stderr = res and ("\n" .. res.stderr) or ""
            msg.error("Failed to detect a language: " .. err .. stderr)
        end
    end)
end

local known_languages = {
    en = true,
    ru = true,
    am = true,
}

local function maybe_enable_subtitles(video_lang)
    msg.debug("Detected language: " .. video_lang)

    if known_languages[video_lang] then
        return
    end

    ---@type {
    ---  id: integer,
    ---  type: ("sub"|"audio"|"video"),
    ---  lang: string?,
    ---  selected: boolean,
    ---}[]
    local tracks = mp.get_property_native("track-list")

    local track_to_enable = nil

    for _, track in ipairs(tracks) do
        if track.type == "sub" then
            if track.selected then
                msg.debug("Track was already selected, skipping...")
                return
            end
            video_lang = track.lang
            if video_lang and video_lang:match("en.*") and not track_to_enable then
                track_to_enable = track
            end
        end
    end

    if track_to_enable then
        mp.set_property("sid", track_to_enable.id)
    end
end

mp.register_event("file-loaded", function()
    local path = mp.get_property_native("path")

    if path:find("^%a[%a%d-_]+://") == nil then
        return
    end

    local metadata = mp.get_property_native("metadata")
    detect_lang_and_run(metadata.title, maybe_enable_subtitles)
end)
