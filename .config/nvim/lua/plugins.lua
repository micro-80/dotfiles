vim.pack.add {
	'https://github.com/bullets-vim/bullets.vim',
	'https://github.com/tpope/vim-sleuth',
}

vim.api.nvim_create_user_command('PackClean', function()
	local packages = vim.pack.get()
	for _, package in pairs(packages) do
		if not package.active then
			vim.pack.del { package.spec.name }
		end
	end
end, {})

vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }
require 'mini.diff'.setup()
require 'mini.git'.setup()
require 'mini.icons'.setup()
require 'mini.notify'.setup()
require 'mini.statusline'.setup()
require 'mini.surround'.setup()

require 'mini.pick'.setup()
vim.keymap.set('n', '`', function() MiniPick.builtin.buffers() end, vim.g.keymap_opts)
vim.keymap.set('n', ';', function() MiniPick.builtin.files() end, vim.g.keymap_opts)
vim.keymap.set('n', '\\', function() MiniPick.builtin.grep_live() end, vim.g.keymap_opts)
vim.keymap.set('n', '<leader>h', function() MiniPick.builtin.help() end, vim.g.keymap_opts)
vim.keymap.set('n', '<leader>gf', function() MiniPick.builtin.files({ tool = 'git' }) end, vim.g.keymap_opts)
vim.keymap.set('n', '<leader>r', function() MiniPick.builtin.resume() end, vim.g.keymap_opts)

vim.pack.add { 'https://github.com/micro-80/ef-themes.nvim' }
vim.cmd.colorscheme("ef-autumn")
