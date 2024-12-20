local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

local function is_nvim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local function term_or_vim_action_callback(actions)
	local function term_or_vim_actions(win, pane)
		if is_nvim(pane) then
			-- pass the keys through to nvim
			for _, vim_action in ipairs(actions.vim_actions) do
				win:perform_action(vim_action, pane)
			end
		else
			for _, term_action in ipairs(actions.term_actions) do
				win:perform_action(term_action, pane)
			end
		end
	end

	return wezterm.action_callback(term_or_vim_actions)
end

local assignments = {
	keys = {
		{
			key = "r",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "resize_pane",
				one_shot = false,
				prevent_fallback = true,
				timeout_milliseconds = 1000,
			}),
		},
		{
			key = "s",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "split_pane",
				one_shot = true,
				prevent_fallback = true,
				timeout_milliseconds = 1000,
			}),
		},
		{
			key = "h",
			mods = "ALT",
			action = term_or_vim_action_callback({
				term_actions = {
					act.ActivatePaneDirection("Left"),
				},
				vim_actions = {
					act.SendKey({ key = "h", mods = "ALT" }),
				},
			}),
		},
		{
			key = "j",
			mods = "ALT",
			action = term_or_vim_action_callback({
				term_actions = {
					act.ActivatePaneDirection("Down"),
				},
				vim_actions = {
					act.SendKey({ key = "j", mods = "ALT" }),
				},
			}),
		},
		{
			key = "k",
			mods = "ALT",
			action = term_or_vim_action_callback({
				term_actions = {
					act.ActivatePaneDirection("Up"),
				},
				vim_actions = {
					act.SendKey({ key = "k", mods = "ALT" }),
				},
			}),
		},
		{
			key = "l",
			mods = "ALT",
			action = term_or_vim_action_callback({
				term_actions = {
					act.ActivatePaneDirection("Right"),
				},
				vim_actions = {
					act.SendKey({ key = "l", mods = "ALT" }),
				},
			}),
		},
	},
	key_tables = {
		split_pane = {
			{ key = "h", action = act.SplitPane({ direction = "Left" }) },
			{ key = "LeftArrow", action = act.SplitPane({ direction = "Left" }) },
			{ key = "l", action = act.SplitPane({ direction = "Right" }) },
			{ key = "RightArrow", action = act.SplitPane({ direction = "Right" }) },
			{ key = "k", action = act.SplitPane({ direction = "Up" }) },
			{ key = "UpArrow", action = act.SplitPane({ direction = "Up" }) },
			{ key = "j", action = act.SplitPane({ direction = "Down" }) },
			{ key = "DownArrow", action = act.SplitPane({ direction = "Down" }) },
		},
		resize_pane = {
			{
				key = "h",
				action = term_or_vim_action_callback({
					term_actions = {
						act.AdjustPaneSize({ "Left", 3 }),
					},
					vim_actions = {
						act.SendKey({ key = "Space", mods = "CTRL" }),
						act.SendKey({ key = "r" }),
						act.SendKey({ key = "LeftArrow" }),
					},
				}),
			},
			{
				key = "LeftArrow",
				action = term_or_vim_action_callback({
					term_actions = {
						act.AdjustPaneSize({ "Left", 3 }),
					},
					vim_actions = {
						act.SendKey({ key = "Space", mods = "CTRL" }),
						act.SendKey({ key = "r" }),
						act.SendKey({ key = "LeftArrow" }),
					},
				}),
			},
			{
				key = "j",
				action = term_or_vim_action_callback({
					term_actions = {
						act.AdjustPaneSize({ "Down", 3 }),
					},
					vim_actions = {
						act.SendKey({ key = "Space", mods = "CTRL" }),
						act.SendKey({ key = "r" }),
						act.SendKey({ key = "DownArrow" }),
					},
				}),
			},
			{
				key = "DownArrow",
				action = term_or_vim_action_callback({
					term_actions = {
						act.AdjustPaneSize({ "Down", 3 }),
					},
					vim_actions = {
						act.SendKey({ key = "Space", mods = "CTRL" }),
						act.SendKey({ key = "r" }),
						act.SendKey({ key = "DownArrow" }),
					},
				}),
			},
			{
				key = "k",
				action = term_or_vim_action_callback({
					term_actions = {
						act.AdjustPaneSize({ "Up", 3 }),
					},
					vim_actions = {
						act.SendKey({ key = "Space", mods = "CTRL" }),
						act.SendKey({ key = "r" }),
						act.SendKey({ key = "UpArrow" }),
					},
				}),
			},
			{
				key = "UpArrow",
				action = term_or_vim_action_callback({
					term_actions = {
						act.AdjustPaneSize({ "Up", 3 }),
					},
					vim_actions = {
						act.SendKey({ key = "Space", mods = "CTRL" }),
						act.SendKey({ key = "r" }),
						act.SendKey({ key = "UpArrow" }),
					},
				}),
			},
			{
				key = "l",
				action = term_or_vim_action_callback({
					term_actions = {
						act.AdjustPaneSize({ "Right", 3 }),
					},
					vim_actions = {
						act.SendKey({ key = "Space", mods = "CTRL" }),
						act.SendKey({ key = "r" }),
						act.SendKey({ key = "RightArrow" }),
					},
				}),
			},
			{
				key = "RightArrow",
				action = term_or_vim_action_callback({
					term_actions = {
						act.AdjustPaneSize({ "Right", 3 }),
					},
					vim_actions = {
						act.SendKey({ key = "Space", mods = "CTRL" }),
						act.SendKey({ key = "r" }),
						act.SendKey({ key = "RightArrow" }),
					},
				}),
			},

			{ key = "q", action = act.PopKeyTable },
			{ key = "Escape", action = act.PopKeyTable },
		},
	},
}

function module.apply_to_config(config)
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
