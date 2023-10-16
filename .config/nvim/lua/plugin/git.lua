local map = vim.keymap.set

require('gitsigns').setup({
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 100,
    },
    map("n", "<leader>c", function() package.loaded.gitsigns.blame_line { full = true } end,
        { desc = "Show git [c]ommit message for the current line" })
})
