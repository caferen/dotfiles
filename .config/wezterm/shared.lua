local wezterm = require 'wezterm'
local act = wezterm.action

local shared = {}

function shared.set_config(config)
	config.enable_tab_bar = false
	config.max_fps = 165
	config.disable_default_key_bindings = true
	config.warn_about_missing_glyphs = false
	config.window_close_confirmation = 'NeverPrompt'
	-- config.unix_domains = {
	-- 	{
	-- 		name = 'unix',
	-- 		local_echo_threshold_ms = 10,
	-- 	},
	-- }
	-- config.default_gui_startup_args = { 'connect', 'unix', '--workspace', tostring({}):sub(10) }

	config.keys = {
		{ key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
		{ key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
		-- { key = 'n', mods = 'ALT',   action = act.ActivateTabRelative(-1) },
		-- { key = 'o', mods = 'ALT',   action = act.ActivateTabRelative(1) },
		-- { key = 't', mods = 'CTRL',  action = act.ActivateKeyTable { name = 'tab_mode' } },
		-- { key = 'v', mods = 'CTRL',  action = act.ActivateCopyMode },
	}

	-- config.key_tables = {
	-- 	tab_mode = {
	-- 		{ key = 'w', mods = 'NONE', action = act.SpawnTab 'CurrentPaneDomain' },
	-- 		{ key = 't', mods = 'NONE', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES|DOMAINS' } },
	-- 		{ key = 'x', mods = 'NONE', action = act.CloseCurrentTab { confirm = false } },
	-- 	},
	-- 	copy_mode = {
	-- 		{ key = 'w',          mods = 'NONE',  action = act.CopyMode 'MoveForwardWord' },
	-- 		{ key = 'b',          mods = 'NONE',  action = act.CopyMode 'MoveBackwardWord' },
	-- 		{ key = 'c',          mods = 'CTRL',  action = act.CopyMode 'Close' },
	-- 		{ key = 'Escape',     mods = 'NONE',  action = act.CopyMode 'ClearSelectionMode' },
	-- 		{ key = '$',          mods = 'NONE',  action = act.CopyMode 'MoveToEndOfLineContent' },
	-- 		{ key = '0',          mods = 'NONE',  action = act.CopyMode 'MoveToStartOfLine' },
	-- 		{ key = 'g',          mods = 'NONE',  action = act.CopyMode 'MoveToScrollbackTop' },
	-- 		{ key = 'G',          mods = 'NONE',  action = act.CopyMode 'MoveToScrollbackBottom' },
	-- 		{ key = 'u',          mods = 'CTRL',  action = act.CopyMode { MoveByPage = (-0.5) } },
	-- 		{ key = 'd',          mods = 'CTRL',  action = act.CopyMode { MoveByPage = (0.5) } },
	-- 		{ key = 'LeftArrow',  mods = 'NONE',  action = act.CopyMode 'MoveLeft' },
	-- 		{ key = 'RightArrow', mods = 'NONE',  action = act.CopyMode 'MoveRight' },
	-- 		{ key = 'UpArrow',    mods = 'NONE',  action = act.CopyMode 'MoveUp' },
	-- 		{ key = 'DownArrow',  mods = 'NONE',  action = act.CopyMode 'MoveDown' },
	-- 		{ key = 'y',          mods = 'NONE',  action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } },
	-- 		{ key = 'v',          mods = 'SHIFT', action = act.CopyMode { SetSelectionMode = 'Line' } },
	-- 		{ key = 'v',          mods = 'NONE',  action = act.CopyMode { SetSelectionMode = 'Word' } },
	-- 	},
	-- }
end

return shared
