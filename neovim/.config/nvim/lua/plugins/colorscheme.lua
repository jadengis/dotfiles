-- VS Code Dark+/Dark Modern. Maintained successor to LunarVim/darkplus.nvim, with
-- highlight groups for blink.cmp, snacks, gitsigns, dropbar, etc.
local M = {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("vscode").setup {
      style = "dark",
    }
    vim.cmd.colorscheme "vscode"
  end,
}

return M
