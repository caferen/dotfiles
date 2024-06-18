local harpoon = require("harpoon")

harpoon:setup({})

vim.keymap.set("n", "<leader>n", function() harpoon:list():append() end)
vim.keymap.set("n", "<leader>w", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<M-Left>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<M-Right>", function() harpoon:list():next() end)
