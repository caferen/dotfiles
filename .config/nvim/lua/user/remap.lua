local map = vim.keymap.set

-- Misc
vim.g.mapleader = " "
vim.g.maplocalleader = " "
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("t", "<esc>", "<C-\\><C-n>")

-- Colemak
local is_colemak = false
local c = { "n", "e", "i", "o", "h", "H", "j", "J", "k", "K", "l", "L" }
local q = { "h", "j", "k", "l", "i", "I", "n", "N", "e", "E", "o", "O" }
local enable_colemak = function()
	print("Colemak active")
	for i, _ in pairs(c) do map({ "n", "v" }, c[i], q[i], { noremap = false }) end
	is_colemak = true
end
vim.api.nvim_create_user_command("TC", function()
	if is_colemak then
		print("QWERTY active")
		for i, _ in pairs(c) do vim.keymap.del({ "n", "v" }, c[i]) end
	else
		enable_colemak()
	end
	is_colemak = not is_colemak
end, {})

vim.system({ "lsusb" }, { text = true }, function(obj)
	if string.find(obj.stdout, "Moonlander") then vim.schedule(enable_colemak) end
	if string.find(obj.stdout, "Keychron") then vim.schedule(enable_colemak) end
end)

map("n", "<leader>x", vim.cmd.Ex, { desc = "File e[x]plorer", noremap = true })

-- LSP
map("n", "<leader>s", vim.lsp.buf.document_symbol, { desc = "List document [s]ymbols" })
map("n", "<leader>S", vim.lsp.buf.workspace_symbol, { desc = "List workspace [S]ymbols" })
map("n", "<leader>r", vim.lsp.buf.rename, { desc = "[r]ename symbol" })
map("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code [a]ctions" })
map("n", "<leader>k", vim.lsp.buf.hover, { desc = "[k] Show documentation" })
map("n", "<leader>h", vim.lsp.buf.signature_help, { desc = "Show signature [h]elp" })

-- Helix-like Goto Mode
map({ "n", "v" }, "gy", vim.lsp.buf.definition, { desc = "[g]oto type definition [y]" })
map({ "n", "v" }, "gr", vim.lsp.buf.references, { desc = "[g]oto [r]eferences" })
map({ "n", "v" }, "gi", vim.lsp.buf.implementation, { desc = "[g]oto [i]mplementation" })
map({ "n", "v" }, "gd", vim.lsp.buf.definition, { desc = "[g]oto [d]eclaration" })
map({ "n", "v" }, "gs", "^", { desc = "[g]oto line [s]tart" })
map({ "n", "v" }, "gl", "$", { desc = "[g]oto [l]ine end" })

-- Diagnostic
map("n", "<leader>d", function()
	vim.diagnostic.get(0)
end, { desc = "List current buffer [d]iagnostics" })
map("n", "<leader>D", vim.diagnostic.get, { desc = "List workspace [D]iagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "[[d] Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "[]d] Go to next diagnostic" })
map("n", "<leader>pd", vim.diagnostic.open_float, { desc = "Open [p]opup [d]iagnostic window" })
