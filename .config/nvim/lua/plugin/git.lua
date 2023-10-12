local map = vim.keymap.set

require('gitsigns').setup({
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 100,
    },
})

-- git_command = { "git", "log", "--format=%B", "-n", "1", "-L" },


map("n", "<leader>c", function()
        local cache = require('gitsigns.cache').cache
        local util = require('gitsigns.util')
        local buf = vim.api.nvim_create_buf(false, true)

        local bcache = cache[0]
        print(bcache)
        if not bcache or not bcache.git_obj.object_name then
            return
        end

        local blame_info = bcache:get_blame(vim.api.nvim_win_get_cursor(0)[1], {})
        print(blame_info)
        blame_info = util.convert_blame_info(blame_info)
        print(blame_info)

        if not blame_info then
            return
        end

        -- Get the current UI
        local ui = vim.api.nvim_list_uis()[1]

        -- Create the floating window
        local opts = {
            relative = 'cursor',
            width = 50,
            height = 10,
            col = 0,
            row = 0,
            style = 'minimal',
            border = "single",
            title = "Git Commit Message",
            noautocmd = true
        }

        local win = vim.api.nvim_open_win(buf, true, opts)
    end,
    { desc = "Show git [c]ommit message for the current line" })
