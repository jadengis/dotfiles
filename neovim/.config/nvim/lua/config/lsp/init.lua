local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim", -- Package manager for Neovim
	  "williamboman/mason-lspconfig.nvim", -- LspConfig for mason.nvim
	  "jose-elias-alvarez/null-ls.nvim",
    "folke/neodev.nvim",
    "utilyre/barbecue.nvim",
  }
}

function M.config()
  require("mason").setup {}
  require("neodev").setup {}
  require("config.lsp.lsp-installer")
  require("config.lsp.null-ls")
  require("config.lsp.handlers").setup()
end

return M
