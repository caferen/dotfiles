-- vim.cmd('colorscheme base16-windows-95')
-- vim.api.nvim_set_hl(0, "@variable", { fg = "#FFFFFF" })
-- vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "#FFFFFF" })


require('monokai').setup { italics = false }

vim.api.nvim_set_hl(0, 'Normal', { guibd = nil })
vim.api.nvim_set_hl(0, 'SignColumn', { guibd = nil })
vim.api.nvim_set_hl(0, 'LineNr', { guibd = nil })
