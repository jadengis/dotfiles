local M = {
  {
    "neovim/nvim-lspconfig", -- provides the lsp/<server>.lua default configs
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local lsp = require "config.lsp"

      require("mason-lspconfig").setup {
        ensure_installed = lsp.servers,
        automatic_enable = false, -- config.lsp enables servers explicitly
      }

      -- Install formatters and other tools that aren't language servers.
      local registry = require "mason-registry"
      registry.refresh(function()
        for _, tool in ipairs(lsp.tools) do
          local ok, pkg = pcall(registry.get_package, tool)
          if ok and not pkg:is_installed() then
            pkg:install()
          end
        end
      end)

      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      lsp.setup()
    end,
  },
  {
    "mason-org/mason.nvim",
    lazy = false, -- cheap, and puts mason's bin/ on PATH for conform's formatters
    opts = {},
  },
  {
    -- Neovim API, plugin and vim.uv types for lua_ls when editing this config.
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
}

return M
