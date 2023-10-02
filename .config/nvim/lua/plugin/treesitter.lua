require('nvim-treesitter.configs').setup {
    ensure_installed = { 'lua', 'python', 'rust', 'tsx', 'typescript', 'bash' },

    auto_install = true,

    highlight = { enable = true },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
        },
    },
}
