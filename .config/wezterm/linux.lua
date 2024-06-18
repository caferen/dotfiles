local linux = {}

function linux.set_config(config)
	config.default_prog = { 'zellij' }
	config.window_padding = { bottom = 0, left = 0 }
	config.font_size = 14.0
	config.enable_wayland = true
	config.window_background_opacity = 0.75
	config.front_end = 'WebGpu'
end

return linux
