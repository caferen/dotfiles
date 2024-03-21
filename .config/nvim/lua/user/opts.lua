if not vim.g.vscode then
	vim.g.netrw_banner = 0
	vim.g.netrw_liststyle = 3
	vim.o.hlsearch = false
	vim.wo.number = true
	vim.wo.signcolumn = 'yes'
	vim.o.relativenumber = true
	vim.o.ignorecase = true
	vim.o.smartcase = true
	vim.o.completeopt = 'menuone,noselect,preview'
	vim.o.termguicolors = true
	vim.o.incsearch = true
	vim.o.smartindent = true
	vim.o.tabstop = 4
	vim.o.softtabstop = 4
	vim.o.shiftwidth = 4
	vim.opt.fillchars = { eob = " " }
	vim.o.laststatus = 0
end
vim.o.showmode = false
vim.o.undofile = true
vim.o.wrap = false
vim.o.scrolloff = 8
vim.o.whichwrap = "bs<>[]hl"
vim.o.clipboard = 'unnamedplus'
