require("neodev").setup()

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-on-attach", { clear = true }),
	callback = function(args)
		local client_id = args.data.client_id
		local client = vim.lsp.get_client_by_id(client_id)
		local bufnr = args.buf

		require("lsp-inlayhints").on_attach(client, bufnr, false)
		vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#696969", bg = nil })

		if not client.server_capabilities.documentFormattingProvider then
			return
		end

		if client.name == "tsserver" then
			return
		end

		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({
					async = false,
					filter = function(c)
						return c.id == client.id
					end,
				})
			end,
		})
	end,
})

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local completion = null_ls.builtins.completion
local diagnostics = null_ls.builtins.diagnostics

local spell = completion.spell
spell.filetypes = { "text" }
null_ls.setup({
	sources = {
		-- spell,
		formatting.beautysh,
		formatting.prettier,
	},
})


local servers = {
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
	rust_analyzer = {
		["rust-analyzer"] = {
			check = { command = "clippy" },
		},
	},
	texlab = {
		build = {
			executable = "tectonic",
			args = {
				"-X",
				"compile",
				"%f",
				"--synctex",
				"--keep-logs",
				"--keep-intermediates"
			},
			onSave = true,
		}
	}
}


require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			settings = servers[server_name],
		})
	end,
})

require("lsp-inlayhints").setup()
