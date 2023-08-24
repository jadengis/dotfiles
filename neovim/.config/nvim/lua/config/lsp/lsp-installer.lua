local status_ok, lsp_installer = pcall(require, "mason-lspconfig")
if not status_ok then
  return
end

local lspconfig = require("lspconfig")

local servers = { "angularls", "tsserver", "jsonls", "html", "cssls", "tailwindcss", "erlangls", "elixirls",
  "lua_ls", "vale_ls", "sorbet" }

lsp_installer.setup {
  ensure_installed = servers,
}

for _, server in pairs(servers) do
  local opts = {
    on_attach = require("config.lsp.handlers").on_attach,
    capabilities = require("config.lsp.handlers").capabilities,
  }

  -- Apply custom settings for all required LSPs
  local has_custom_opts, server_custom_opts = pcall(require, "config.lsp.opts." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
  end
  lspconfig[server].setup(opts)
end
