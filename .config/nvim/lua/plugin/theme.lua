-- vim.cmd('colorscheme base16-windows-95')
-- vim.api.nvim_set_hl(0, "@variable", { fg = "#FFFFFF" })
-- vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "#FFFFFF" })
--
-- vim.api.nvim_set_hl(0, 'Normal', { guibd = nil })
-- vim.api.nvim_set_hl(0, 'SignColumn', { guibd = nil })
-- vim.api.nvim_set_hl(0, 'LineNr', { guibd = nil })

-- require("cyberdream").setup({ transparent = true })
-- vim.cmd("colorscheme cyberdream")

require('github-theme').setup({ options = { transparent = true } })
vim.cmd('colorscheme github_dark_default')
vim.api.nvim_set_hl(0, 'TelescopeBorder', { gui = nil, guisp = nil })
vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { gui = nil, guisp = nil })
