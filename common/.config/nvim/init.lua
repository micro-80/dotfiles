local lsp_ensure_installed = { "lua_ls", "stylua", "vtsls"}
local treesitter_file_types = { "c", "lua", "typescript", "tsx" }

local set_key = vim.keymap.set
local keymap_defaults = { noremap = true, silent = true }

vim.g.mapleader = " "

vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.inccommand = "split"
vim.o.number = true
--vim.o.relativenumber = true
vim.o.pumborder = "single"
vim.o.scrolloff = 10
vim.o.signcolumn = "yes"
vim.o.termguicolors = true

vim.cmd("colorscheme default")

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = treesitter_file_types,
	callback = function(args)
		local bufnr = args.buf
		if not pcall(vim.treesitter.start, bufnr) then
			return
		end
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

set_key("n", "<leader>d", vim.diagnostic.open_float, keymap_defaults)
set_key("n", "<leader>ca", vim.lsp.buf.code_action, keymap_defaults)
set_key("n", "<leader>f", vim.lsp.buf.format, keymap_defaults)
set_key("n", "<leader>rn", vim.lsp.buf.rename, keymap_defaults)

vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/tpope/vim-sleuth",
	-- copilot
	"https://github.com/CopilotC-Nvim/CopilotChat.nvim",
	"https://github.com/nvim-lua/plenary.nvim" -- dependency
})

require("mini.completion").setup()
require("mini.icons").setup()
require("mini.notify").setup()
require("mini.surround").setup()

require("mini.cmdline").setup({
	autocomplete = {
		enable = false,
	},
	autocorrect = {
		enable = false
	},
})

-- require("mini.hues")
-- vim.cmd("colorscheme miniwinter")

local mini_pick = require("mini.pick")
mini_pick.setup()
set_key("n", "<leader>h", mini_pick.builtin.help, keymap_defaults)
set_key("n", "\\", mini_pick.builtin.grep_live, keymap_defaults)
set_key("n", ",", mini_pick.builtin.buffers, keymap_defaults)
set_key("n", ";", mini_pick.builtin.files, keymap_defaults)

require("nvim-treesitter").install(treesitter_file_types)

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({ensure_installed = lsp_ensure_installed})
