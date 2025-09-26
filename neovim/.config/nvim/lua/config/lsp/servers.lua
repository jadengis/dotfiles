local status_ok, lsp_installer = pcall(require, "mason-lspconfig")
if not status_ok then
  return
end

local mason_managed_servers = {
  "ts_ls",
  "jsonls",
  "html",
  "cssls",
  "tailwindcss",
  "elixirls",
  --[[ "expert", ]]
  "lua_ls",
  "texlab",
  "sqlls",
}
lsp_installer.setup({
  automatic_enable = false,
  ensure_installed = mason_managed_servers,
})

local servers = vim.list_extend({
  --[[ "expert" ]]
}, mason_managed_servers)
for _, server in pairs(servers) do
  -- Apply custom settings for all required LSPs
  local opts = {}
  local has_custom_opts, server_custom_opts = pcall(require, "config.lsp.opts." .. server)
  if has_custom_opts then
    opts = server_custom_opts
  end
  local client = require("config.lsp.client").setup(opts)
  opts = vim.tbl_deep_extend("force", opts, {
    on_attach = client.on_attach,
    capabilities = client.capabilities,
  })

  vim.lsp.config(server, opts)
  vim.lsp.enable(server)
end
