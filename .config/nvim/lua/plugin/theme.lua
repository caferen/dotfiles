-- vim.cmd('colorscheme base16-windows-95')
-- vim.api.nvim_set_hl(0, "@variable", { fg = "#FFFFFF" })
-- vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "#FFFFFF" })
--
-- vim.api.nvim_set_hl(0, 'Normal', { guibd = nil })
-- vim.api.nvim_set_hl(0, 'SignColumn', { guibd = nil })
-- vim.api.nvim_set_hl(0, 'LineNr', { guibd = nil })

require("cyberdream").setup({ transparent = true })
vim.cmd("colorscheme cyberdream")

vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = "#000000", fg = "#000000" })
vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { bg = "#000000", fg = "#000000" })
vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { bg = "#000000", fg = "#000000" })
vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = "#000000", fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg = "#000000", fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg = "#000000", fg = "#FFFFFF" })
