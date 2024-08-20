local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

local spec = {
  {"nvim-lua/popup.nvim", lazy = false},
  {"nvim-lua/plenary.nvim", lazy = false},
  {"moll/vim-bbye", lazy = false},
  require "config.colorscheme",
  require "config.illuminate",
  require "config.cmp",
  require "config.luasnip",
  require "config.breadcrumbs",
  {
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "VimEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    }
	},
  {
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup({})
		end,
	},
  require "config.codeium",
  require "config.lsp",
  require "config.dap",
  require "config.telescope",
  require "config.treesitter",
  require "config.autopairs",
  require "config.comment",
  require "config.gitsigns",
  require "config.nvim-tree",
  require "config.bufferline",
  require "config.lualine",
  require "config.indent_blankline",
  require "config.sessions",
  require "config.colorizer",
  require "config.notify",
  require "config.dadbod",
}

require("lazy").setup {
  spec = spec,
  install = {
    colorscheme = { "darkplus", "default" },
  },
  ui = {
    border = "rounded",
  }
}
