local wezterm = require("wezterm")
local io = require("io")
local os = require("os")
local act = wezterm.action

local module = {}

local function trigger_scrollback(win, pane)
    -- Retrieve the text from the pane
    local text = pane:get_logical_lines_as_text(pane:get_dimensions().scrollback_rows)

    -- Create a temporary file to pass to nvim
    local tmp_filename = os.tmpname()
    local scrollback_file = io.open(tmp_filename, "w+")
    if scrollback_file == nil then
        return
    end
    scrollback_file:write(text)
    scrollback_file:flush()
    scrollback_file:close()

    -- Open a new window running nvim and tell it to open the file
    win:perform_action(
        act.SpawnCommandInNewTab({
            args = { "nvim", "-c", "set filetype=scrollback | $", tmp_filename },
        }),
        pane
    )

    -- Wait "enough" time for nvim to read the file before we remove it.
    -- The window creation and process spawn are asynchronous wrt. running
    -- this script and are not awaitable, so we just pick a number.
    --
    -- Note: We don't strictly need to remove this file, but it is nice
    -- to avoid cluttering up the temporary directory.
    wezterm.sleep_ms(1000)
    os.remove(tmp_filename)
end

local assignments = {
    keys = {
        {
            key = "t",
            mods = "LEADER",
            action = wezterm.action_callback(trigger_scrollback),
        },
    },
    key_tables = {},
}

function module.apply_to_config(config)
    config.switch_to_last_active_tab_when_closing_tab = true

    if config.keys == nil then
        config.keys = {}
    end
    if config.key_tables == nil then
        config.key_tables = {}
    end

    for _, key in ipairs(assignments.keys) do
        table.insert(config.keys, key)
    end

    for key_table_name, key_table in pairs(assignments.key_tables) do
        config.key_tables[key_table_name] = key_table
    end
end

return module
