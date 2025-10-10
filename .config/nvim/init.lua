vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.winborder = "single"
vim.opt.signcolumn = "yes:1"
vim.opt.linebreak = true
vim.opt.tabstop = 4
vim.opt.swapfile = false

vim.g.mapleader = " "
vim.keymap.set('n', "<A-w>", ':bd<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>y", '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>d", '"+d<CR>')

vim.cmd [[set completeopt+=menuone,noselect,popup]]
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})
vim.lsp.enable({ "lua_ls" })
vim.keymap.set('n', "<leader>lf", vim.lsp.buf.format)

vim.pack.add({
	"https://github.com/NMAC427/guess-indent.nvim",
	"https://github.com/L3MON4D3/LuaSnip",
	--"https://github.com/mason-org/mason.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/vague-theme/vague.nvim",
})

require('guess-indent').setup {}

require('mini.pick').setup {}
vim.keymap.set('n', "<leader>pb", ":Pick buffers<CR>")
vim.keymap.set('n', "<leader>pf", ":Pick files<CR>")
vim.keymap.set('n', "<leader>ph", ":Pick help<CR>")
vim.keymap.set('n', "<leader>pg", ":Pick grep_live<CR>")
vim.keymap.set('n', "<leader>pr", ":Pick resume<CR>")

require('oil').setup {
	columns = {
		"permissions",
		"size",
		"mtime"
	},
	watch_for_changes = true,
	view_options = {
		show_hidden = true
	},
}
vim.keymap.set('n', "<leader>e", ":Oil<CR>")

require('vague').setup {
	style = {
		strings = "none"
	}
}
vim.cmd("colorscheme vague")
