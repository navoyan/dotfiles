local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.color_scheme = "tokyonight"
config.window_background_opacity = 0.95

config.font = wezterm.font("JetBrains Mono Nerd Font")
config.font_size = 14

config.use_fancy_tab_bar = false
config.tab_max_width = 32

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1500 }
config.default_prog = { "/usr/bin/fish" }

config.disable_default_key_bindings = true
config.keys = {
    { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
    { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
    { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
    {
        key = "c",
        mods = "LEADER",
        action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
        key = "q",
        mods = "LEADER",
        action = act.CloseCurrentTab({ confirm = true }),
    },
    {
        key = "x",
        mods = "LEADER",
        action = act.CloseCurrentPane({ confirm = true }),
    },
    {
        key = "z",
        mods = "LEADER",
        action = act.TogglePaneZoomState,
    },
    {
        key = "e",
        mods = "LEADER",
        action = act.ActivateCopyMode,
    },
    {
        key = "f",
        mods = "LEADER",
        action = act.Search("CurrentSelectionOrEmptyString"),
    },
    -- Select emojis (why do I even need this? 🥴)
    {
        key = "U",
        mods = "LEADER",
        action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
    },
    {
        key = "T",
        mods = "LEADER",
        action = act.ActivateKeyTable({
            name = "edit_term",
            one_shot = false,
            prevent_fallback = true,
            timeout_milliseconds = 1000,
        }),
    },
}
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = "ALT",
        action = act.ActivateTab(i - 1),
    })
    table.insert(config.keys, {
        key = tostring(i),
        mods = "CTRL|ALT",
        action = act.MoveTab(i - 1),
    })
end

local default_key_tables = wezterm.gui.default_key_tables()
local copy_mode = default_key_tables.copy_mode
-- table.insert(copy_mode, {
-- 	key = "V",
-- 	action = act.CopyMode({ SetSelectionMode = "SemanticZone" }),
-- })

config.key_tables = {
    copy_mode = copy_mode,
    search_mode = default_key_tables.search_mode,
    edit_term = {
        { key = "f", action = act.IncreaseFontSize },
        { key = "F", action = act.DecreaseFontSize },

        {
            key = "z",
            action = wezterm.action_callback(function(win, pane)
                win:perform_action(act.ResetFontSize, pane)
                win:perform_action(act.PopKeyTable, pane)
            end),
        },
        {
            key = "s",
            action = wezterm.action_callback(function(win, pane)
                win:perform_action(act.ToggleFullScreen, pane)
                win:perform_action(act.PopKeyTable, pane)
            end),
        },
        {
            key = "c",
            action = wezterm.action_callback(function(win, pane)
                win:perform_action(act.ClearScrollback("ScrollbackOnly"), pane)
                win:perform_action(act.PopKeyTable, pane)
            end),
        },
        {
            key = "o",
            action = wezterm.action_callback(function(win, pane)
                win:perform_action(act.ShowDebugOverlay, pane)
                win:perform_action(act.PopKeyTable, pane)
            end),
        },
        {
            key = "p",
            action = wezterm.action_callback(function(win, pane)
                win:perform_action(act.ActivateCommandPalette, pane)
                win:perform_action(act.PopKeyTable, pane)
            end),
        },
        {
            key = "r",
            action = wezterm.action_callback(function(win, pane)
                win:perform_action(act.ReloadConfiguration, pane)
                win:perform_action(act.PopKeyTable, pane)
            end),
        },

        { key = "q", action = act.PopKeyTable },
        { key = "Escape", action = act.PopKeyTable },
    },
}

-- Fixes CloseCurrentTab and CloseCurrentPane confirmation dialogs
config.skip_close_confirmation_for_processes_named = {}

require("scrollback").apply_to_config(config)
require("splits").apply_to_config(config)

return config
