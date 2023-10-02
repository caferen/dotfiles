require('nvim-treesitter.configs').setup {
    ensure_installed = { 'lua', 'python', 'rust', 'tsx', 'typescript', 'bash' },
    auto_install = true,
    highlight = { enable = true },
}
