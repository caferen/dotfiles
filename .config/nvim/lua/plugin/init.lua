if not vim.g.vscode then
	require('plugin.theme')
	require('plugin.cmp')
	require('plugin.lsp')
	require('plugin.treesitter')
	require('plugin.telescope')
	require('plugin.harpoon')
	require('plugin.lualine')

	local handle = io.popen("uname")
	local kernel = handle:read("a")
	handle:close()
	if string.find(kernel, "Linux") then
		require('plugin.ollama')
	end
end
