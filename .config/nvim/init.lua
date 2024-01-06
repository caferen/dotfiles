require('user')
require('plugin')

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    pattern = '*',
})

require("no-neck-pain").setup({
    buffers = {
        right = {
            enabled = false,
        },
    },
})

require('gitsigns').setup({
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 100,
    },
    vim.keymap.set("n", "<leader>gc", function() package.loaded.gitsigns.blame_line { full = true } end,
        { desc = "Show [g]it [c]ommit message for the current line" })
})

local enable_colemak = function(obj)
    if string.find(obj.stdout, "Moonlander") then
        vim.schedule(function() vim.cmd("TC") end)
    end
end

vim.system({ "lsusb" }, { text = true }, enable_colemak)
