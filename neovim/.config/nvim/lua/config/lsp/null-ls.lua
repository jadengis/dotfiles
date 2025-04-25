local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
  debug = false,
  sources = {
    -- Lua
    formatting.stylua,

    -- JavaScript / WebDev
    formatting.prettier,
    require("none-ls.code_actions.eslint"),
    require("none-ls.diagnostics.eslint"),
    diagnostics.stylint,

    -- Elixir
    --[[ diagnostics.credo, ]]
  }
}
