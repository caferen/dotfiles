require("github-theme").setup({
    options = {
        transparent = true,
        darken = {
            floats = true,
            sidebars = {
                enable = true,
                list = { "netrw" },
            },
        },
    },
})

vim.cmd.colorscheme("github_dark_high_contrast")
