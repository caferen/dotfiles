local map = vim.keymap.set
local code = require('vscode-neovim')

map('n', '<leader>f', function() code.call('workbench.action.quickOpen') end, { noremap = true })
map('n', '<leader>b', function() code.call('workbench.action.showAllEditors') end, { noremap = true })
map('n', '<leader>v', function() code.call('workbench.action.openView') end, { noremap = true })
map('n', '/', function() code.call('actions.find') end, { noremap = true })
map('n', '<leader>/', function() code.call('workbench.action.findInFiles') end, { noremap = true })

-- LSP
map('n', '<leader>s', function() code.call('workbench.action.gotoSymbol') end)
map('n', '<leader>S', function() code.call('workbench.action.showAllSymbols') end)
map('n', '<leader>r', function() code.call('editor.action.rename') end)
map('n', '<leader>a', function() code.call('editor.action.quickFix') end)
map('n', '<leader>k', function() code.call('editor.action.showHover') end)
map('n', '<leader>h', function() code.call('editor.action.showDefinitionPreviewHover') end)

-- Helix-like Goto Mode
map({ 'n', 'v' }, 'gy', function() code.call('editor.action.goToTypeDefinition') end)
map({ 'n', 'v' }, 'gr', function() code.call('editor.action.goToReferences') end)
map({ 'n', 'v' }, 'gi', function() code.call('editor.action.goToImplementation') end)
map({ 'n', 'v' }, 'gd', function() code.call('editor.action.revealDefinition') end)

-- Peeks
map({ 'n', 'v' }, 'py', function() code.call('editor.action.peekTypeDefinition') end)
map({ 'n', 'v' }, 'pr', function() code.call('editor.action.referenceSearch.trigger') end)
map({ 'n', 'v' }, 'pi', function() code.call('editor.action.peekImplementation') end)
map({ 'n', 'v' }, 'pd', function() code.call('editor.action.peekDefinition') end)

-- Diagnostic
map('n', '<leader>d', function() code.call('workbench.actions.view.problems') end)
map('n', '<leader>D', function() code.call('workbench.action.showErrorsWarnings') end)
map('n', ']d', function() code.call('editor.action.marker.next') end)
map('n', '[d', function() code.call('editor.action.marker.prev') end)

-- Harpoon
map('n', '<leader>n', function() code.call('vscode-harpoon.addGlobalEditor') end)
map('n', '<leader>w', function() code.call('vscode-harpoon.editorGlobalQuickPick') end)
map('n', 'A-Left', function() code.call('vscode-harpoon.gotoPreviousGlobalHarpoonEditor') end)
-- map('n', 'A-Right', function() code.call('vscode-harpoon.editorGlobalQuickPick') end)

vim.api.nvim_create_autocmd("InsertEnter", {
    group = vim.api.nvim_create_augroup('ClosePanel', { clear = true }),
    callback = function()
        code.call('workbench.action.closePanel')
    end
})
