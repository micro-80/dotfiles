vim.pack.add {
	'https://github.com/mason-org/mason.nvim',
	'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
	'https://github.com/neovim/nvim-lspconfig'
}

vim.lsp.enable({
	'efm',
	'lua_ls'
})
require 'mason'.setup()
require 'mason-tool-installer'.setup({
	ensure_installed = {
		-- lsp
		'efm',
		'lua-language-server',
		-- tools
		'shellcheck'
	}
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method 'textDocument/completion' then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
		if client:supports_method 'textDocument/inlayHint' then
			vim.lsp.inlay_hint.enable(true)
		end
	end,
})

vim.keymap.set({ 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help)
vim.keymap.set('n', 'gfo', vim.lsp.buf.format)

local shellcheck = {
	lintCommand = "shellcheck -f gcc -x -",
	lintStdin = true,
	lintFormats = {
		"%f:%l:%c: %trror: %m",
		"%f:%l:%c: %tarning: %m",
		"%f:%l:%c: %tote: %m",
	},
}

vim.lsp.config('efm', {
	filetypes = { 'bash', 'sh', 'zsh' },
	settings = {
		bash = { shellcheck },
		sh = { shellcheck },
		zsh = { shellcheck },
	}
})

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = {
					'vim',
					'require'
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
