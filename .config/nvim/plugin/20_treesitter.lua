local treesitter_install = {
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

vim.pack.add {
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
}

require 'nvim-treesitter'.install(treesitter_install)
vim.api.nvim_create_autocmd('FileType', {
	desc = 'Enable Tree-sitter highlighting and folds',
	pattern = '*',
	callback = function()
		local ok, lang = pcall(vim.treesitter.language.get_lang, vim.bo.filetype)
		if ok then
			pcall(vim.treesitter.start)
			---@cast lang string
			if vim.treesitter.query.get(lang, 'folds') then
				vim.opt_local.foldmethod = 'expr'
				vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
				vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end
	end,
})

