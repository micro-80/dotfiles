local enabled_lsps = {
	'lua_ls',
	'markdown_oxide'
}

vim.pack.add {
	'https://github.com/mason-org/mason.nvim',
	'https://github.com/mason-org/mason-lspconfig.nvim',
	'https://github.com/neovim/nvim-lspconfig'
}

require 'mason'.setup()
require 'mason-lspconfig'.setup { ensure_installed = enabled_lsps }
vim.lsp.enable(enabled_lsps)
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method 'textDocument/completion' then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
vim.keymap.set({ 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help)

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			completion = { callSnippet = 'Replace' },
			runtime = {
				version = 'LuaJIT',
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
				},
			},
		},
	},
})
