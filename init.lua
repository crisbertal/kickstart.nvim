vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	'tpope/vim-sleuth',
	'RRethy/base16-nvim',
	-- {
	-- 	'RRethy/base16-nvim',
	-- 	config = function ()
	-- 		-- NOTE: from https://github.com/nekonako/xresources-nvim/blob/master/lua/xresources.lua#L86 
	-- 		local function get_xresources_color (c)
	-- 			local command = io.popen('xrdb -query | grep ' .. c .. ' -m 1 | cut -f 2')
	-- 			local color = command:read("*l")
	-- 			return color
	-- 		end

	-- 		require('base16-colorscheme').setup({
	-- 			base00 = get_xresources_color('color8'), base01 = get_xresources_color('color0'), base02 = get_xresources_color('color10'), base03 = get_xresources_color('color11'),
	-- 			base04 = get_xresources_color('color12'), base05 = get_xresources_color('color14'), base06 = get_xresources_color('color7'), base07 = get_xresources_color('color15'),
	-- 			base08 = get_xresources_color('color1'), base09 = get_xresources_color('color9'), base0A = get_xresources_color('color2'), base0B = get_xresources_color('color3'),
	-- 			base0C = get_xresources_color('color6'), base0D = get_xresources_color('color4'), base0E = get_xresources_color('color13'), base0F = get_xresources_color('color5'),
	-- 		})
	-- 	end
	-- },
	-- {
	-- 	'rose-pine/neovim',
	-- 	name = "rose-pine",
	-- 	config = function()
	-- 		require("rose-pine").setup({
	-- 			styles = { transparency = true }
	-- 		})
	-- 		vim.cmd("colorscheme rose-pine")
	-- 	end
	-- },
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, {})
			vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, {})
			vim.keymap.set('n', '<leader>giw', require('telescope.builtin').grep_string, {})
			vim.keymap.set('n', '<leader>lg', require('telescope.builtin').live_grep, {})
		end
	},
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" },
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end
	},
	{
		"mbbill/undotree",
		config = function()
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
		end
	},
	{
		"ThePrimeagen/harpoon",
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<leader>a", mark.add_file)
			vim.keymap.set("n", "<leader>oh", ui.toggle_quick_menu)
			vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
			vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
			vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
			vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)
		end
	},
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
		end
	},

	-- LSP plugins
	-- LSP Support
	{ 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
	{ 'neovim/nvim-lspconfig' },
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },

	-- Autocompletion
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/nvim-cmp' },

	-- Snippets
	{ "rafamadriz/friendly-snippets" },
	{ "honza/vim-snippets" },
	{
		'L3MON4D3/LuaSnip',
		dependencies = { "rafamadriz/friendly-snippets" }
	},

	-- status line
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup({})
		end
	},

	-- Highlight todo, notes, etc in comments
	{ 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

	-- commentary
	{ 'tpope/vim-commentary' },

	-- formatter
	{
		'stevearc/conform.nvim',
		config = function()
			require("conform").setup({
				format_on_save = {
					timeout_ms = 500,
					async = false,
					quiet = false,
				},
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					lua = { "stylua" },
					-- python = { "black" },
				},
			})
		end,
	}
})

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
	handlers = {
		lsp_zero.default_setup,
	},
	ensure_installed = { "pyright" }
})

-- [[ Configure nvim-cmp ]] From kickstart nvim: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_snipmate').lazy_load()

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	completion = {
		completeopt = 'menu,menuone,noinsert',
	},
	mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete {},
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'path' },
	},
}

-- colorscheme
vim.cmd("colorscheme base16-rose-pine")

-- terminal color
vim.o.termguicolors = true

-- turn lff search highlight
vim.o.hlsearch = false

-- relative numbers
vim.o.relativenumber = true

-- save undo history
vim.o.undofile = true

-- column line at 88 chars
vim.opt.colorcolumn = "88"

vim.opt.scrolloff = 8

-- file explorer
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

-- common clipboard
vim.o.clipboard = ''

-- integration with external clipboard (xclip must be installed)
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>P", '"+P')
