require("nvim-treesitter.configs").setup {
	ensure_installed = { "lua", "python", "rust", "bash" },

	auto_install = true,

	highlight = { enable = true },
	indent = { enable = true },
	-- incremental_selection = {
	-- 	enable = true,
	-- 	keymaps = {
	-- 		init_selection = "<C-space>",
	-- 		node_incremental = "<C-space>",
	-- 		scope_incremental = "<C-s>",
	-- 		node_decremental = "<A-space>",
	-- 	},
	-- },
	-- textobjects = {
	-- 	select = {
	-- 		enable = true,
	-- 		lookahead = true,
	-- 		keymaps = {
	-- 			["ap"] = "@parameter.outer",
	-- 			["ip"] = "@parameter.inner",
	-- 			["af"] = "@function.outer",
	-- 			["if"] = "@function.inner",
	-- 			["ac"] = "@class.outer",
	-- 			["ic"] = "@class.inner",
	-- 		},
	-- 	},
	-- 	move = {
	-- 		enable = true,
	-- 		set_jumps = true,
	-- 		goto_next_start = {
	-- 			["]fs"] = "@function.outer",
	-- 			["]cs"] = "@class.outer",
	-- 		},
	-- 		goto_previous_start = {
	-- 			["[Fs"] = "@function.outer",
	-- 			["[Cs"] = "@class.outer",
	-- 		},
	-- 		-- goto_next_end = {
	-- 		-- 	["]fe"] = "@function.outer",
	-- 		-- 	["]ce"] = "@class.outer",
	-- 		-- },
	-- 		-- goto_previous_end = {
	-- 		-- 	["[Fe"] = "@function.outer",
	-- 		-- 	["[Ce"] = "@class.outer",
	-- 		-- },
	-- 		-- goto_next = {
	-- 		-- 	["]d"] = "@conditional.outer",
	-- 		-- },
	-- 		-- goto_previous = {
	-- 		-- 	["[d"] = "@conditional.outer",
	-- 		-- }
	-- 	},
	-- 	-- swap = {
	-- 	--     enable = true,
	-- 	--     swap_next = {
	-- 	--         ["<leader>a"] = "@parameter.inner",
	-- 	--     },
	-- 	--     swap_previous = {
	-- 	--         ["<leader>A"] = "@parameter.inner",
	-- 	--     },
	-- 	-- },
	-- },
}
