vim.pack.add {
	'https://github.com/bullets-vim/bullets.vim',
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

vim.pack.add { 'https://github.com/nvim-mini/mini.icons' }
require('mini.icons').setup()

vim.pack.add { 'https://github.com/nvim-mini/mini.pick' } -- for the love of god, please install ripgrep before using!
require('mini.pick').setup()
vim.keymap.set('n', ';', function() MiniPick.builtin.files() end)
vim.keymap.set('n', ',', function() MiniPick.builtin.buffers() end)
vim.keymap.set('n', '\\', function() MiniPick.builtin.grep_live() end)
vim.keymap.set('n', '<leader>h', function() MiniPick.builtin.help() end)
vim.keymap.set('n', '<leader>gf', function() MiniPick.builtin.files({ tool = 'git' }) end)
vim.keymap.set('n', '<leader>r', function() MiniPick.builtin.resume() end)

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

-- vim.pack.add { 'https://github.com/miikanissi/modus-themes.nvim' }
-- require 'modus-themes'.setup {
-- 	line_nr_column_background = false,
-- 	sign_column_background = false,
-- 	variant = 'default'
-- }
-- vim.cmd [[colorscheme modus_vivendi]]
-- vim.pack.add { 'https://github.com/micro-80/ef-dream.nvim' }
-- require 'modus-themes'.setup {
-- 	line_nr_column_background = false,
-- 	sign_column_background = false,
-- }
-- vim.cmd [[colorscheme ef_dream]]
vim.pack.add { 'https://github.com/micro-80/ef-themes.nvim' }
vim.cmd.colorscheme("ef-autumn")
