vim.pack.add {
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
}

local treesitter_grammars = {
	'bash',
	'c',
	'c_sharp',
	'cpp',
	'css',
	'csv',
	'git_config',
	'gitcommit',
	'gitignore',
	'go',
	'gomod',
	'html',
	'hurl',
	'java',
	'json',
	'lua',
	'markdown',
	'python',
	'sql',
	'svelte',
	'toml',
	'yaml',
	'rust',
	'javascript',
	'typescript'
}

require 'nvim-treesitter'.install(treesitter_grammars)

vim.api.nvim_create_autocmd('FileType', {
	pattern = { '*' },
	callback = function()
		if vim.treesitter.get_parser(nil, nil, { error = false }) then
			vim.treesitter.start()
			vim.opt_local.foldmethod = 'expr'
			vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
			vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
