require('gitsigns').setup {
	signcolumn                   = false,
	current_line_blame           = true,
	current_line_blame_opts      = {
		virt_text = true,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 50,
	},
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
}

vim.keymap.set("n", "<leader>c", function() package.loaded.gitsigns.blame_line { full = true } end,
	{ desc = "Show git [c]ommit message for the current line" })
