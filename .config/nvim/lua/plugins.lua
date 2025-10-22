vim.pack.add {
	'https://github.com/bullets-vim/bullets.vim',
	'https://github.com/nvim-tree/nvim-web-devicons', -- oil + fzf-lua
	'https://github.com/tpope/vim-fugitive',
	'https://github.com/tpope/vim-repeat',
	'https://github.com/tpope/vim-sleuth',
	'https://github.com/tpope/vim-surround',
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

vim.pack.add { 'https://github.com/ibhagwan/fzf-lua' }
local fzf_lua = require 'fzf-lua'
fzf_lua.setup {
	keymap = {
		fzf = {
			['ctrl-q'] = 'select-all+accept'
		}
	}
}
vim.keymap.set('n', '<C-\\>', fzf_lua.buffers)
vim.keymap.set('n', '<C-p>', fzf_lua.files)
vim.keymap.set('n', '<C-l>', fzf_lua.live_grep)
vim.keymap.set('n', '<leader>fd', fzf_lua.diagnostics_document)
vim.keymap.set('n', '<leader>fw', fzf_lua.diagnostics_workspace)
vim.keymap.set('n', '<leader>ff', fzf_lua.files)
vim.keymap.set('n', '<leader>gbl', fzf_lua.git_blame)
vim.keymap.set('n', '<leader>gbr', fzf_lua.git_branches)
vim.keymap.set('n', '<leader>gc', fzf_lua.git_commits)
vim.keymap.set('n', '<leader>gd', fzf_lua.git_diff)
vim.keymap.set('n', '<leader>gf', fzf_lua.git_files)
vim.keymap.set('n', '<leader>gh', fzf_lua.git_hunks)
vim.keymap.set('n', '<leader>gs', fzf_lua.git_stash)
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

local function fzf_lua_tmux_sessionizer()
	fzf_lua.fzf_exec('ts --list', {
		actions = {
			['default'] = function(selected)
				vim.fn.system('ts ' .. selected[1])
			end
		}
	})
end
vim.keymap.set('n', '<leader>t', fzf_lua_tmux_sessionizer)

vim.pack.add { 'https://github.com/nvim-mini/mini.statusline' }
require 'mini.statusline'.setup {}

vim.pack.add { 'https://github.com/stevearc/oil.nvim' }
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

vim.pack.add { 'https://github.com/miikanissi/modus-themes.nvim' }
require 'modus-themes'.setup {
	line_nr_column_background = false,
	sign_column_background = false,
	variant = 'default'
}
vim.cmd [[colorscheme modus_vivendi]]
