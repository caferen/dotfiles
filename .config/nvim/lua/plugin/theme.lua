-- Red
vim.cmd [[highlight clear]]

local highlight = function(group, bg, fg, attr)
    fg = fg and 'guifg=' .. fg or ''
    bg = bg and 'guibg=' .. bg or ''
    attr = attr and 'gui=' .. attr or ''

    vim.api.nvim_command('highlight ' .. group .. ' ' .. fg .. ' ' .. bg .. ' ' .. attr)
end

local link = function(target, group)
    vim.api.nvim_command('highlight! link ' .. target .. ' ' .. group)
end

local Color10 = '#390000'
local Color5 = '#fb9a4b'
local Color14 = '#300a0a'
local Color3 = '#ff6262'
local Color4 = '#cd8d8d'
local Color9 = '#F8F8F8'
local Color11 = '#490000'
local Color6 = '#ffffff'
local Color1 = '#994646'
local Color8 = '#700000'
local Color12 = '#750000'
local Color13 = '#a23f3f'
local Color7 = '#ec0d1e'
local Color2 = '#f12727'
local Color0 = '#e7c0c0'

highlight('Comment', nil, Color0, 'italic')
highlight('Constant', nil, Color1, nil)
highlight('Keyword', nil, Color2, nil)
highlight('Type', nil, Color3, 'bold')
highlight('String', nil, Color4, nil)
highlight('Identifier', nil, Color5, 'italic')
highlight('Error', nil, Color6, nil)
highlight('TSCharacter', nil, Color7, nil)
highlight('StatusLine', nil, Color8, nil)
highlight('WildMenu', Color10, Color9, nil)
highlight('Pmenu', Color10, Color9, nil)
highlight('PmenuSel', Color9, Color11, nil)
highlight('PmenuThumb', Color10, Color9, nil)
highlight('Normal', Color10, Color9, nil)
highlight('Visual', Color12, nil, nil)
highlight('CursorLine', Color12, nil, nil)
highlight('ColorColumn', Color12, nil, nil)
highlight('SignColumn', Color10, nil, nil)
highlight('LineNr', nil, Color13, nil)
highlight('TabLine', Color14, nil, nil)
highlight('TabLineSel', nil, Color11, nil)
highlight('TabLineFill', Color14, nil, nil)
highlight('TSPunctDelimiter', nil, Color9, nil)

link('TSParameter', 'Constant')
link('NonText', 'Comment')
link('TSFloat', 'Number')
link('TSKeyword', 'Keyword')
link('TSField', 'Constant')
link('TSNamespace', 'TSType')
link('TelescopeNormal', 'Normal')
link('TSFuncMacro', 'Macro')
link('Macro', 'Function')
link('TSPunctBracket', 'MyTag')
link('TSRepeat', 'Repeat')
link('Repeat', 'Conditional')
link('Whitespace', 'Comment')
link('TSComment', 'Comment')
link('TSNumber', 'Number')
link('TSConstBuiltin', 'TSVariableBuiltin')
link('TSType', 'Type')
link('TSString', 'String')
link('Folded', 'Comment')
link('TSConstant', 'Constant')
link('Operator', 'Keyword')
link('TSProperty', 'TSField')
link('TSParameterReference', 'TSParameter')
link('TSTag', 'MyTag')
link('TSOperator', 'Operator')
link('CursorLineNr', 'Identifier')
link('TSLabel', 'Type')
link('Conditional', 'Operator')
link('TSTagDelimiter', 'Type')
link('TSFunction', 'Function')
link('TSPunctSpecial', 'TSPunctDelimiter')
link('TSConditional', 'Conditional')

-- Abyss
-- vim.cmd[[highlight clear]]
--
-- local highlight = function(group, bg, fg, attr)
--     fg = fg and 'guifg=' .. fg or ''
--     bg = bg and 'guibg=' .. bg or ''
--     attr = attr and 'gui=' .. attr or ''
--
--     vim.api.nvim_command('highlight ' .. group .. ' '.. fg .. ' ' .. bg .. ' '.. attr)
-- end
--
-- local link = function(target, group)
--     vim.api.nvim_command('highlight! link ' .. target .. ' '.. group)
-- end
--
-- local Color5 = '#ddbb88'
-- local Color0 = '#384887'
-- local Color7 = '#10192c'
-- local Color11 = '#491e30'
-- local Color3 = '#225588'
-- local Color6 = '#A22D44'
-- local Color4 = '#ffeebb'
-- local Color8 = '#000c18'
-- local Color1 = '#22aa44'
-- local Color10 = '#10393e'
-- local Color12 = '#770811'
-- local Color9 = '#6688cc'
-- local Color13 = '#406385'
-- local Color2 = '#f280d0'
--
-- highlight('Comment', nil, Color0, nil)
-- highlight('String', nil, Color1, nil)
-- highlight('Number', nil, Color2, nil)
-- highlight('TSCharacter', nil, Color2, nil)
-- highlight('Keyword', nil, Color3, nil)
-- highlight('Type', nil, Color3, nil)
-- highlight('Type', nil, Color4, nil)
-- highlight('Function', nil, Color5, nil)
-- highlight('Error', nil, Color6, nil)
-- highlight('StatusLine', nil, Color7, nil)
-- highlight('WildMenu', Color8, Color9, nil)
-- highlight('Pmenu', Color8, Color9, nil)
-- highlight('PmenuSel', Color9, nil, nil)
-- highlight('PmenuThumb', Color8, Color9, nil)
-- highlight('DiffAdd', Color10, nil, nil)
-- highlight('DiffDelete', Color11, nil, nil)
-- highlight('Normal', Color8, Color9, nil)
-- highlight('Visual', Color12, nil, nil)
-- highlight('CursorLine', Color12, nil, nil)
-- highlight('ColorColumn', Color12, nil, nil)
-- highlight('SignColumn', Color8, nil, nil)
-- highlight('LineNr', nil, Color13, nil)
-- highlight('TabLine', Color7, nil, nil)
-- highlight('TabLineFill', Color7, nil, nil)
-- highlight('TSPunctDelimiter', nil, Color9, nil)
--
-- link('TSComment', 'Comment')
-- link('TSFunction', 'Function')
-- link('TSConditional', 'Conditional')
-- link('TSLabel', 'Type')
-- link('TSProperty', 'TSField')
-- link('CursorLineNr', 'Identifier')
-- link('TSString', 'String')
-- link('TSPunctBracket', 'MyTag')
-- link('TSTagDelimiter', 'Type')
-- link('TSNamespace', 'TSType')
-- link('TSKeyword', 'Keyword')
-- link('Folded', 'Comment')
-- link('NonText', 'Comment')
-- link('Macro', 'Function')
-- link('Operator', 'Keyword')
-- link('TSParameterReference', 'TSParameter')
-- link('TSField', 'Constant')
-- link('TSFloat', 'Number')
-- link('TSConstBuiltin', 'TSVariableBuiltin')
-- link('TSTag', 'MyTag')
-- link('TelescopeNormal', 'Normal')
-- link('Whitespace', 'Comment')
-- link('TSNumber', 'Number')
-- link('TSRepeat', 'Repeat')
-- link('TSParameter', 'Constant')
-- link('TSConstant', 'Constant')
-- link('TSPunctSpecial', 'TSPunctDelimiter')
-- link('Repeat', 'Conditional')
-- link('TSOperator', 'Operator')
-- link('Conditional', 'Operator')
-- link('TSFuncMacro', 'Macro')
-- link('TSType', 'Type')
