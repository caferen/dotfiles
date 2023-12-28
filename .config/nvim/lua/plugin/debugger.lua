local dap = require('dap')
local map = vim.keymap.set

dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/local/bin/lldb-vscode', -- adjust as needed, must be absolute path
    name = 'lldb'
}

dap.configurations.cpp = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        env = function()
            local variables = {}
            for k, v in pairs(vim.fn.environ()) do
                table.insert(variables, string.format("%s=%s", k, v))
            end
            return variables
        end,
    },
}

map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle [d]ebug [b]reakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "[c]ontiune execution" })
map("n", "<leader>di", dap.step_into, { desc = "step [i]nto code" })
map("n", "<leader>do", dap.step_over, { desc = "step [o]ver code" })
map("n", "<leader>dlj", function()
    require('dap.ext.vscode').load_launchjs(nil, { lldb = { 'rust' } })
end, { desc = "[l]oad the {cwd}/.vscode/launch.[j]son" })
