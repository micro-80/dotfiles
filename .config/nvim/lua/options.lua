vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.conceallevel = 2
vim.opt.pumborder = 'single'
vim.opt.pumheight = 7
vim.opt.winborder = 'single'
vim.opt.signcolumn = 'yes:1'
vim.opt.linebreak = true
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.foldtext = ''
vim.opt.foldlevel = 99
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.swapfile = false
vim.opt.complete = '.,w,b,o,u'
vim.opt.autocomplete = false
vim.opt.completeopt = 'menuone,noselect,popup'

vim.g.mapleader = ' '
vim.keymap.set('n', '<A-w>', ':bd<CR>')
vim.keymap.set("n", "<C-q>", "<cmd>cclose<CR>")
vim.keymap.set("n", "<C-w>", "<cmd>copen<CR>")
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
