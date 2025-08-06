local status_ok, lsp_installer = pcall(require, "mason-lspconfig")
if not status_ok then
  return
end

local lspconfig = require("lspconfig")

local servers = {
  "tsserver",
  "jsonls",
  "html",
  "cssls",
  "tailwindcss",
  --[[ "erlangls", ]]
  "elixirls",
  "lua_ls",
  "texlab",
  "sqlls",
}

lsp_installer.setup({
  ensure_installed = servers,
})

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
  lspconfig[server].setup(opts)
end
