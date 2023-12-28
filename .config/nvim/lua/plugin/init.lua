if not vim.g.vscode then
    require('plugin.theme')
    require('plugin.cmp')
    require('plugin.lsp')
    require('plugin.git')
    require('plugin.lualine')
    require('plugin.treesitter')
    require('plugin.telescope')
    require('plugin.debugger')
end
