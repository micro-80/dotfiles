local enabled_lsps = {
	'lua_ls',
	'markdown-oxide'
}
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

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.conceallevel = 2
vim.opt.pumborder = 'single'
vim.opt.pumheight = 7
vim.opt.winborder = 'single'
vim.opt.signcolumn = 'yes:1'
vim.opt.linebreak = true
vim.opt.tabstop = 4
vim.opt.foldtext = ''
vim.opt.foldlevel = 99
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.swapfile = false
vim.opt.complete = '.,o'
vim.opt.autocomplete = false
vim.opt.completeopt = 'fuzzy,menuone,noselect,popup'

vim.g.mapleader = ' '
vim.keymap.set('n', '<A-w>', ':bd<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set('n', 'f', 'gwip')
vim.keymap.set('n', 'F', function()
	local pos = vim.api.nvim_win_get_cursor(0)
	vim.cmd 'normal! ggVGgw'
	vim.api.nvim_win_set_cursor(0, pos)
end)

vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end)

vim.api.nvim_create_autocmd('FileType', {
	desc = 'Enable spellcheck on text files',
	pattern = { 'markdown', 'text', 'gitcommit' },
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = 'en_gb'
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	desc = '80 character width on gitcommit files',
	pattern = { 'gitcommit' },
	callback = function()
		vim.opt_local.colorcolumn = '80'
		vim.opt_local.textwidth = 80
	end,
})

local home = vim.fn.expand '~'
vim.api.nvim_create_autocmd('BufEnter', {
	desc = 'Set text width 120 for Notes folder',
	pattern = home .. '/Notes/**',
	callback = function()
		vim.opt_local.colorcolumn = '120'
		vim.opt_local.textwidth = 120
	end,
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method 'textDocument/completion' then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})
vim.lsp.enable(enabled_lsps)
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
vim.keymap.set({ 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help)

vim.pack.add {
	'https://github.com/bullets-vim/bullets.vim',
	'https://github.com/ibhagwan/fzf-lua',
	'https://github.com/nvim-mini/mini.nvim',
	'https://github.com/stevearc/oil.nvim',
	'https://github.com/vague-theme/vague.nvim',
	'https://github.com/tpope/vim-sleuth',

	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
}

-- https://github.com/neovim/neovim/issues/35303
vim.api.nvim_create_user_command('PackClean', function()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print 'No unused plugins.'
		return
	end

	vim.pack.del(unused_plugins)
end, {})

vim.api.nvim_create_user_command('PackUpdate', function()
	vim.pack.update()
end, {})

local fzf_lua = require 'fzf-lua'
vim.keymap.set('n', '<leader>fb', fzf_lua.buffers)
vim.keymap.set('n', '<leader>fd', fzf_lua.diagnostics_document)
vim.keymap.set('n', '<leader>fw', fzf_lua.diagnostics_workspace)
vim.keymap.set('n', '<leader>ff', fzf_lua.files)
vim.keymap.set('n', '<leader>gf', fzf_lua.git_files)
vim.keymap.set('n', '<leader>fh', fzf_lua.help_tags)
vim.keymap.set('n', '<leader>fk', fzf_lua.keymaps)
vim.keymap.set('n', '<leader>fm', fzf_lua.man_pages)
vim.keymap.set('n', '<leader>fs', fzf_lua.live_grep)
vim.keymap.set('n', '<leader>fr', fzf_lua.resume)

vim.keymap.set('n', '<leader>la', fzf_lua.lsp_code_actions)
vim.keymap.set('n', '<leader>lc', fzf_lua.lsp_declarations)
vim.keymap.set('n', '<leader>ld', fzf_lua.lsp_definitions)
vim.keymap.set('n', '<leader>li', fzf_lua.lsp_implementations)
vim.keymap.set('n', '<leader>lr', fzf_lua.lsp_references)
vim.keymap.set('n', '<leader>ls', fzf_lua.lsp_document_symbols)
vim.keymap.set('n', '<leader>lt', fzf_lua.lsp_typedefs)

vim.keymap.set('n', 'z=', fzf_lua.spell_suggest)
vim.keymap.set('n', 'z=', fzf_lua.spell_suggest)

require 'mini.diff'.setup {}
require 'mini.extra'.setup {}
require 'mini.git'.setup {}
require 'mini.icons'.setup {}
require 'mini.indentscope'.setup {}
require 'mini.notify'.setup {}
require 'mini.statusline'.setup {}
require 'mini.surround'.setup {}

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

local oil = require 'oil'
oil.setup {
	watch_for_changes = true,
	columns = {
		'permissions',
		'size',
		'mtime',
		'icon'
	},
	view_options = {
		show_hidden = true,
	},
}
vim.keymap.set('n', '<leader>e', oil.open)

require 'vague'.setup {
	style = {
		strings = 'none'
	}
}
vim.cmd 'colorscheme vague'
