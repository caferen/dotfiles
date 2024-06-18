local wezterm = require 'wezterm'
local shared = require('shared')

local config = wezterm.config_builder()

shared.set_config(config)

if string.find(wezterm.target_triple, 'darwin') then
	require('darwin').set_config(config)
elseif string.find(wezterm.target_triple, 'linux') then
	require('linux').set_config(config)
end

return config
