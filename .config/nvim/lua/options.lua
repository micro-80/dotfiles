-- Line Numbers & Cursor
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.cursorline     = true
vim.opt.cursorlineopt  = 'number'
vim.opt.scrolloff      = 10
-- Interface & Display
vim.opt.showmode       = false
vim.opt.conceallevel   = 2       -- Conceal text (for markdown, LaTeX, etc.)
vim.opt.linebreak      = true    -- Wrap lines at word boundaries
vim.opt.breakindent    = true    -- Indent wrapped lines
vim.opt.foldtext       = ''
vim.opt.foldlevel      = 99      -- Open all folds by default
vim.opt.signcolumn     = 'yes:1' -- Always show sign column
-- Popup Menus & Completion
-- vim.opt.completeopt    = { "menuone", "menu" }
vim.opt.pumborder      = 'bold'
vim.opt.pumheight      = 7
vim.opt.pummaxwidth    = 100
vim.opt.winborder      = 'single'
-- Indentation
vim.opt.expandtab      = false -- Use tabs instead of spaces
vim.opt.tabstop        = 4     -- Spaces per tab
vim.opt.shiftwidth     = 4     -- Indentation width for << and >>
vim.opt.softtabstop    = 4     -- Spaces for tab in insert mode
-- Assorted
vim.opt.swapfile       = false -- Disable swap files

vim.g.showbreak        = '↪'
vim.g.mapleader        = ' '
vim.g.keymap_opts      = { noremap = true, silent = true }

vim.keymap.set('n', '<A-w>', ':bd<CR>', vim.g.keymap_opts)
vim.keymap.set('n', 'tl', ':set list!<CR>', vim.g.keymap_opts)
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>', vim.g.keymap_opts)
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>', vim.g.keymap_opts)
vim.keymap.set('n', 'f', 'gwip', vim.g.keymap_opts)
vim.keymap.set('n', 'F', function()
	local pos = vim.api.nvim_win_get_cursor(0)
	vim.cmd 'normal! ggVGgw'
	vim.api.nvim_win_set_cursor(0, pos)
end, vim.g.keymap_opts)
-- TODO: replace with https://github.com/neovim/neovim/issues/33914 when merged
vim.keymap.set('n', ',', function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == 'netrw' then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	vim.cmd('Lexplore %:p:h')
end, vim.g.keymap_opts)

vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end, vim.g.keymap_opts)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end, vim.g.keymap_opts)
