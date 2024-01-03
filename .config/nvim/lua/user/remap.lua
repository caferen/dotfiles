local map = vim.keymap.set

-- Misc
vim.g.mapleader = " "
vim.g.maplocalleader = " "
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

-- Colemak
local is_colemak = false
vim.api.nvim_create_user_command("TCol", function()
    local layout_map = function(a, b)
        map({ "n", "v" }, a, b, { noremap = false })
    end
    local layout_del = function(a)
        vim.keymap.del({ "n", "v" }, a)
    end

    if is_colemak then
        print("QWERTY active")
        layout_del("n")
        layout_del("e")
        layout_del("i")
        layout_del("o")

        layout_del("h")
        layout_del("H")

        layout_del("j")
        layout_del("J")

        layout_del("k")
        layout_del("K")

        layout_del("l")
        layout_del("L")
    else
        print("Colemak active")
        layout_map("n", "h")
        layout_map("e", "j")
        layout_map("i", "k")
        layout_map("o", "l")

        layout_map("h", "i")
        layout_map("H", "I")

        layout_map("j", "n")
        layout_map("J", "N")

        layout_map("k", "e")
        layout_map("K", "E")

        layout_map("l", "o")
        layout_map("L", "O")
    end
    is_colemak = not is_colemak
end, {})
vim.api.nvim_create_autocmd(
    "VimEnter",
    { group = vim.api.nvim_create_augroup("ToggleColemak", { clear = true }), command = "TCol" }
)

map("n", "<leader>x", vim.cmd.Ex, { desc = "File e[x]plorer", noremap = true })

-- LSP
map("n", "<leader>s", vim.lsp.buf.document_symbol, { desc = "List document [s]ymbols" })
map("n", "<leader>S", vim.lsp.buf.workspace_symbol, { desc = "List workspace [S]ymbols" })
map("n", "<leader>r", vim.lsp.buf.rename, { desc = "[r]ename symbol" })
map("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code [a]ctions" })
map("n", "<leader>k", vim.lsp.buf.hover, { desc = "[k] Show documentation" })
map("n", "<leader>h", vim.lsp.buf.signature_help, { desc = "Show signature [h]elp" })

-- Helix-like Goto Mode
map({ "n", "v" }, "gy", vim.lsp.buf.definition, { desc = "[g]oto type definition [y]" })
map({ "n", "v" }, "gr", vim.lsp.buf.references, { desc = "[g]oto [r]eferences" })
map({ "n", "v" }, "gi", vim.lsp.buf.implementation, { desc = "[g]oto [i]mplementation" })
map({ "n", "v" }, "gd", vim.lsp.buf.definition, { desc = "[g]oto [d]eclaration" })
map({ "n", "v" }, "gs", "^", { desc = "[g]oto line [s]tart" })
map({ "n", "v" }, "gl", "$", { desc = "[g]oto [l]ine end" })

-- Diagnostic
map("n", "<leader>d", function()
    vim.diagnostic.get(0)
end, { desc = "List current buffer [d]iagnostics" })
map("n", "<leader>D", vim.diagnostic.get, { desc = "List workspace [d]iagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "[[d] Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "[]d] Go to next diagnostic" })
map("n", "<leader>pd", vim.diagnostic.open_float, { desc = "Open [p]opup [d]iagnostic window" })
