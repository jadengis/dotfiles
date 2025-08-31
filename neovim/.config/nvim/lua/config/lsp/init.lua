local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason.nvim",          -- Package manager for Neovim
    "mason-org/mason-lspconfig.nvim", -- LspConfig for mason.nvim
    "nvimtools/none-ls.nvim",
    "nvimtools/none-ls-extras.nvim",
    "folke/neodev.nvim",
    "utilyre/barbecue.nvim",
  }
}

function M.config()
  require("mason").setup {}
  require("neodev").setup {}
  require("config.lsp.servers")
  require("config.lsp.null-ls")
  require("config.lsp.handlers").setup()
end

return M
