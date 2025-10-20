vim.opt.spell = true
vim.opt.spelllang = 'en_gb'

local filepath = vim.fn.expand('%:p')
local notes_dir = vim.fn.expand('~/Notes')
if vim.startswith(filepath, notes_dir) then
	vim.opt_local.colorcolumn = '120'
	vim.opt_local.textwidth = 120
end
