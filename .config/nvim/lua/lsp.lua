vim.pack.add {
	'https://github.com/mason-org/mason.nvim',
	'https://github.com/neovim/nvim-lspconfig'
}

local lsp_servers = {
	clangd = 'clangd',
	efm = 'efm',
	lua_ls = 'lua-language-server',
	gopls = 'gopls',
}

local tools = {
	'shellcheck'
}

vim.lsp.enable(vim.tbl_keys(lsp_servers))

require 'mason'.setup()
vim.api.nvim_create_user_command("MasonInstallAll", function()
	local registry = require('mason-registry')
	local packages = vim.list_extend(vim.tbl_values(lsp_servers), tools)
	for _, package_name in ipairs(packages) do
		local package = registry.get_package(package_name)
		if not package:is_installed() then
			vim.cmd("MasonInstall " .. package_name)
		end
	end
end, {})

vim.keymap.set({ 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help, vim.g.keymap_opts)
vim.keymap.set('n', 'gfo', vim.lsp.buf.format, vim.g.keymap_opts)

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client_id = args.data.client_id
		local client = assert(vim.lsp.get_client_by_id(client_id))

		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
		end
	end,
})

local shellcheck = {
	lintCommand = 'shellcheck -f gcc -x -',
	lintStdin = true,
	lintFormats = {
		'%f:%l:%c: %trror: %m',
		'%f:%l:%c: %tarning: %m',
		'%f:%l:%c: %tote: %m',
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
				library = vim.api.nvim_get_runtime_file('', true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
