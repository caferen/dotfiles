local wezterm = require 'wezterm'
local act = wezterm.action
local darwin = {}

function darwin.set_config(config)
	config.window_padding = {
		left = 0,
		right = '0.5cell',
		top = '1.5cell',
		bottom = 0,
	}
	config.window_background_opacity = 0.75
	config.macos_window_background_blur = 75
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	config.font_size = 16.0
	config.unix_domains = {
		{
			name = 'unix',
			local_echo_threshold_ms = 10,
		},
	}
	config.default_gui_startup_args = { 'connect', 'unix', '--workspace', tostring({}):sub(10) }


	table.insert(config.keys, { key = 'n', mods = 'ALT', action = act.ActivateTabRelative(-1) })
	table.insert(config.keys, { key = 'o', mods = 'ALT', action = act.ActivateTabRelative(1) })
	table.insert(config.keys, { key = 't', mods = 'CTRL', action = act.ActivateKeyTable { name = 'tab_mode' } })
	table.insert(config.keys, { key = 'v', mods = 'CTRL', action = act.ActivateCopyMode })


	config.key_tables = {
		tab_mode = {
			{ key = 'w', mods = 'NONE', action = act.SpawnTab 'CurrentPaneDomain' },
			{ key = 't', mods = 'NONE', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES|DOMAINS' } },
			{ key = 'x', mods = 'NONE', action = act.CloseCurrentTab { confirm = false } },
		},
		copy_mode = {
			{ key = 'w',          mods = 'NONE',  action = act.CopyMode 'MoveForwardWord' },
			{ key = 'b',          mods = 'NONE',  action = act.CopyMode 'MoveBackwardWord' },
			{ key = 'c',          mods = 'CTRL',  action = act.CopyMode 'Close' },
			{ key = 'Escape',     mods = 'NONE',  action = act.CopyMode 'ClearSelectionMode' },
			{ key = '$',          mods = 'NONE',  action = act.CopyMode 'MoveToEndOfLineContent' },
			{ key = '0',          mods = 'NONE',  action = act.CopyMode 'MoveToStartOfLine' },
			{ key = 'g',          mods = 'NONE',  action = act.CopyMode 'MoveToScrollbackTop' },
			{ key = 'G',          mods = 'NONE',  action = act.CopyMode 'MoveToScrollbackBottom' },
			{ key = 'u',          mods = 'CTRL',  action = act.CopyMode { MoveByPage = (-0.5) } },
			{ key = 'd',          mods = 'CTRL',  action = act.CopyMode { MoveByPage = (0.5) } },
			{ key = 'LeftArrow',  mods = 'NONE',  action = act.CopyMode 'MoveLeft' },
			{ key = 'RightArrow', mods = 'NONE',  action = act.CopyMode 'MoveRight' },
			{ key = 'UpArrow',    mods = 'NONE',  action = act.CopyMode 'MoveUp' },
			{ key = 'DownArrow',  mods = 'NONE',  action = act.CopyMode 'MoveDown' },
			{ key = 'y',          mods = 'NONE',  action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } },
			{ key = 'v',          mods = 'SHIFT', action = act.CopyMode { SetSelectionMode = 'Line' } },
			{ key = 'v',          mods = 'NONE',  action = act.CopyMode { SetSelectionMode = 'Word' } },
		},
	}
end

return darwin
