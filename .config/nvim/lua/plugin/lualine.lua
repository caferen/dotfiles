local lualine = require('lualine')

lualine.setup {
	options = {
		icons_enabled = true,
		theme = 'base16',
		globalstatus = true,
		component_separators = '|',
		section_separators = '',
	},
	sections = {
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = {
			{
				'filename',
				file_status = true,
				path = 1
			},
		},
		lualine_x = {
			{
				'lsp_progress',
				display_components = { { 'title', 'message' } },
			},
		},
		lualine_y = { 'encoding', 'fileformat', 'filetype', 'progress' },
		--lualine_z = { "os.date('%d %b')", "os.date('%H:%M')" }
		lualine_z = { 'location' }
	},
}

local unhide = false
local function toggle_simple_ui()
	lualine.hide({ unhide = unhide })
	vim.o.showmode = not unhide
	vim.wo.number = unhide
	vim.o.relativenumber = unhide
	-- if not unhide then
	-- 	vim.o.foldcolumn = '9'
	-- 	vim.o.signcolumn = 'yes:9'
	-- else
	-- 	vim.o.foldcolumn = '0'
	-- 	vim.o.signcolumn = 'yes'
	-- end
	unhide = not unhide
end

vim.keymap.set('n', '<leader>l', toggle_simple_ui)
