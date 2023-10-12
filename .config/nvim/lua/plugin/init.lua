if not vim.g.vscode then
    require('plugin.theme')
    require('plugin.cmp')
    require('plugin.lsp')
    require('plugin.lualine')
    require('plugin.telescope')
    require('plugin.treesitter')
    require('plugin.gitsigns')
end
