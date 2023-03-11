local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require("mason").setup {}
require("neodev").setup {}
require("config.lsp.lsp-installer")
require("config.lsp.null-ls")
require("config.lsp.handlers").setup()
