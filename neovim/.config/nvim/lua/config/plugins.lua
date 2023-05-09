local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim ...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API frim vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used by lots of plugins
	use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp
	use("numToStr/Comment.nvim") -- Easily comment stuff
	use("kyazdani42/nvim-web-devicons")
	use("kyazdani42/nvim-tree.lua")
	use("akinsho/bufferline.nvim")
	use("nvim-lualine/lualine.nvim")
	use("moll/vim-bbye")
	use("lewis6991/impatient.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("akinsho/toggleterm.nvim")
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})
	use("rmagatti/auto-session")
	use("norcalli/nvim-colorizer.lua")
	use("rcarriga/nvim-notify")
	-- use "folke/which-key.nvim"

	-- Colorschemes
	use("jadengis/darkplus.nvim")

	-- cmp plugins
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-nvim-lsp") -- nvim-lsp completions
	use("hrsh7th/cmp-nvim-lua") -- nvim-lua completions
	use({
		"David-Kunz/cmp-npm",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	}) -- npm completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	--[[ use "github/copilot.vim" -- GitHub Co-pilot ]]
	use({
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "VimEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	})
	use({
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup({})
		end,
	})

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/mason.nvim") -- Package manager for Neovim
	use("williamboman/mason-lspconfig.nvim") -- LspConfig for mason.nvim
	use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters
	use("onsails/lspkind.nvim")
	use("RRethy/vim-illuminate")
	use("folke/neodev.nvim") -- Neovim specific completions.

	-- DAP
	use("mfussenegger/nvim-dap") -- enable DAP
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	--[[ use "nvim-telescope/telescope-dap.nvim" ]]
	use("nvim-telescope/telescope-media-files.nvim")

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("nvim-treesitter/playground")
	use("jadengis/nvim-ts-autotag")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Git
	use("lewis6991/gitsigns.nvim")

	-- Hook into activitywatch.
	--[[ use("ActivityWatch/aw-watcher-vim") ]]

	use({
		"nvim-neorg/neorg",
    tag = "v3.1.0",
		run = ":Neorg sync-parsers",
		config = require("config.neorg").setup,
	})

	-- Automatically set up your configuratin after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
