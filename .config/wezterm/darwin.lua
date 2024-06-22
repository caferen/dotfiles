local wezterm = require 'wezterm'
local act = wezterm.action
local darwin = {}

function darwin.set_config(config)
	config.default_prog = { '/opt/homebrew/bin/zellij' }
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
end

return darwin
