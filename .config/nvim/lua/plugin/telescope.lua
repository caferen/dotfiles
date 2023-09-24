require('telescope').setup {
    defaults = {
        sorting_strategy = "ascending",
        mappings = {
            i = {
                ['<esc>'] = require('telescope.actions').close,
                ['<C-i>'] = require('telescope.actions').move_selection_next,
                ['<C-e>'] = require('telescope.actions').move_selection_previous,
            },
        },
        layout_config = {
            horizontal = {
                prompt_position = "top",
                width = 0.99,
                height = 0.99,
                preview_width = 0.6,
            },
        },
    },
    extensions = {
        ['ui-select'] = {}
    }
}

local map = vim.keymap.set
local tb = require('telescope.builtin')

-- File pickers
map('n', '<leader>f', tb.find_files, { desc = 'List [f]iles', noremap = true })
map('n', '<leader>g', tb.git_files, { desc = 'List [g]it files', noremap = true })
map('n', '<leader>b', tb.buffers, { desc = 'List open [b]uffers' })

-- Search
map('n', '<leader>w', tb.grep_string, { desc = 'search current [w]ord' })
map('n', '<leader>/', tb.live_grep, { desc = '[<leader>/] Fuzzily search in current workspace' })

pcall(require('telescope').load_extension, 'fzf')

local path = vim.fn.argv(0)
vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup("DirFiles", { clear = true }),
    callback = function()
        if vim.fn.isdirectory(path) ~= 0 then
            vim.api.nvim_set_current_dir(path)
            local is_git = vim.fn.finddir('.git', path)
            -- I'd expect this to work in reverse
            if is_git ~= "" then
                require('telescope.builtin').git_files()
            else
                require('telescope.builtin').find_files()
            end
        end
    end
})
