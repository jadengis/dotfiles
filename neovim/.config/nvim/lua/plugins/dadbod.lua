local M = {
  "kristijanhusak/vim-dadbod-ui",
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    -- completion source for blink.cmp (plugins/completion.lua)
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}

return M
