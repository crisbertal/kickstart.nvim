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
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function () 
			vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, {})
			vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, {})
			vim.keymap.set('n', '<leader>gs', require('telescope.builtin').grep_string, {})
			vim.keymap.set('n', '<leader>lg', require('telescope.builtin').live_grep, {})
		end
	},
	{ 
		'rose-pine/neovim', 
		name = "rose-pine",
		config = function () 
			vim.cmd("colorscheme rose-pine")
		end
	},
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		config = function () 
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
		-- TODO create snippets for Flask
		"L3MON4D3/LuaSnip",
		version = "v2.*", 
		build = "make install_jsregexp"
	},
	{
		"mbbill/undotree",
		config = function() 
			vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)	
		end
	},
	{
		"ThePrimeagen/harpoon",
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function () 
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<leader>a", mark.add_file)
			vim.keymap.set("n", "<leader>oh", ui.toggle_quick_menu)
			vim.keymap.set("n", "<C-h>", function () ui.nav_file(1) end)
			vim.keymap.set("n", "<C-j>", function () ui.nav_file(2) end)
			vim.keymap.set("n", "<C-k>", function () ui.nav_file(3) end)
			vim.keymap.set("n", "<C-l>", function () ui.nav_file(4) end)
		end
	},
	{
		"tpope/vim-fugitive",
		config = function () 
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git)		
		end
	}
})

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)
