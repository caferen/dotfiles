if not vim.g.vscode then
    require('plugin.theme')
    require('plugin.cmp')
    require('plugin.lsp')
    require('plugin.lualine')
    require('plugin.treesitter')
    require('plugin.git')
    require('plugin.telescope')
end
