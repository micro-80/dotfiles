vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.conceallevel = 2
vim.opt.pumborder = "single"
vim.opt.winborder = "single"
vim.opt.signcolumn = "yes:1"
vim.opt.linebreak = true
vim.opt.tabstop = 4
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.exrc = true
vim.opt.secure = true
vim.opt.swapfile = false

vim.g.mapleader = " "
vim.keymap.set('n', "<A-w>", ':bd<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>d", '"+d<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>y", '"+y<CR>')
vim.keymap.set("n", "f", "gwip")
vim.keymap.set("n", "F", function()
  vim.cmd("normal! m'gggqG`'")
end)


vim.keymap.set('n', "<leader>d", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)

vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable spellcheck on text files",
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = "en_gb"
	end,
})

local home = vim.fn.expand("~")
vim.api.nvim_create_autocmd("BufEnter", {
	desc = "Set text width 120 for Notes folder",
	pattern = home .. "/Notes/**",
	callback = function()
		vim.opt_local.colorcolumn = "120"
		vim.opt_local.textwidth = 120
	end,
})

vim.cmd [[set completeopt+=fuzzy,menuone,noselect,popup]]
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})
vim.lsp.enable({ "lua_ls", "markdown-oxide" })
vim.keymap.set('n', "<leader>la", vim.lsp.buf.code_action)
vim.keymap.set('n', "<leader>lf", vim.lsp.buf.format)
vim.keymap.set('n', "<leader>r", vim.lsp.buf.rename)
vim.keymap.set({ 'n', 'i' }, "<C-s>", vim.lsp.buf.signature_help)

vim.pack.add({
	"https://github.com/bullets-vim/bullets.vim",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/vague-theme/vague.nvim",
	"https://github.com/tpope/vim-sleuth",

	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require('mini.diff').setup {}
require('mini.extra').setup {}
require('mini.git').setup {}
require('mini.icons').setup {}
require('mini.pick').setup {}
require('mini.notify').setup {}
require('mini.statusline').setup {}
require('mini.surround').setup {}

local pick = require("mini.pick").builtin
local extra = require("mini.extra")
vim.ui.select = pick.ui_select

vim.keymap.set('n', '<leader>pb', pick.buffers)
vim.keymap.set("n", "<leader>pd", extra.pickers.diagnostic)
vim.keymap.set('n', '<leader>pf', pick.files)
vim.keymap.set('n', '<leader>pgf', function()
	pick.files({ tool = 'git' })
end)
vim.keymap.set('n', '<leader>ph', pick.help)
vim.keymap.set("n", "<leader>pk", extra.pickers.keymaps)
vim.keymap.set('n', '<leader>ps', pick.grep_live)
vim.keymap.set('n', '<leader>pr', pick.resume)

vim.keymap.set('n', "<leader>ld", function() extra.pickers.lsp({ scope = 'definition' }) end)
vim.keymap.set('n', "<leader>li", function() extra.pickers.lsp({ scope = 'implementation' }) end)
vim.keymap.set('n', "<leader>lr", function() extra.pickers.lsp({ scope = 'references' }) end)
vim.keymap.set('n', "<leader>lt", function() extra.pickers.lsp({ scope = 'type_definition' }) end)

vim.keymap.set("n", "z=", extra.pickers.spellsuggest)

require('nvim-treesitter').install { 'c', 'c_sharp', 'cpp', 'css', 'csv', 'git_config', 'gitcommit', 'gitignore', 'go', 'gomod', 'html', 'hurl', 'java', 'json', 'lua', 'markdown', 'python', 'sql', 'svelte', 'toml', 'yaml', 'rust', 'javascript', 'typescript' }
vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable Tree-sitter highlighting and folds",
	pattern = "*",
	callback = function()
		local ok, lang = pcall(vim.treesitter.language.get_lang, vim.bo.filetype)
		if ok then
			pcall(vim.treesitter.start)
			---@cast lang string
			if vim.treesitter.query.get(lang, "folds") then
				vim.opt_local.foldmethod = "expr"
				vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end
	end,
})

require('oil').setup {
	columns = {
		"permissions",
		"size",
		"mtime",
		"icon"
	},
}
vim.keymap.set('n', "<leader>e", ":Oil<CR>")

require('vague').setup {
	style = {
		strings = "none"
	}
}
vim.cmd("colorscheme vague")
