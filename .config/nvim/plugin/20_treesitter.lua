vim.pack.add {
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
}

local treesitter_to_install = _G.treesitter_grammars or {}
require 'nvim-treesitter'.install(treesitter_to_install)
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

