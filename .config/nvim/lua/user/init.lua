if not vim.g.vscode then
    require('user.lazy')
end

require('user.opts')
require('user.remap')

if vim.g.vscode then
    require('user.vscode')
end
