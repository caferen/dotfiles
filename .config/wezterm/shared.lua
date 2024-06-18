local wezterm = require 'wezterm'
local act = wezterm.action

local shared = {}

function shared.set_config(config)
	config.font = wezterm.font 'MesloLGS NF'
	config.enable_tab_bar = false
	config.max_fps = 165
	config.disable_default_key_bindings = true
	config.warn_about_missing_glyphs = false
	config.window_close_confirmation = 'NeverPrompt'

	config.keys = {
		{ key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
		{ key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
	}
end

return shared
