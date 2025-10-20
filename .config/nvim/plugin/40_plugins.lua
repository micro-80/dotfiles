vim.pack.add {
	'https://github.com/bullets-vim/bullets.vim',
	'https://github.com/ibhagwan/fzf-lua',
	'https://github.com/nvim-mini/mini.nvim',
	'https://github.com/stevearc/oil.nvim',
	'https://github.com/vague-theme/vague.nvim',
	'https://github.com/tpope/vim-sleuth',
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

require 'mini.diff'.setup {}
require 'mini.extra'.setup {}
require 'mini.git'.setup {}
require 'mini.icons'.setup {}
require 'mini.indentscope'.setup {}
require 'mini.notify'.setup {}
require 'mini.statusline'.setup {}
require 'mini.surround'.setup {}

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
