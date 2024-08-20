local M = {
  "LunarVim/darkplus.nvim",
  config = function ()
    vim.cmd.colorscheme "darkplus"

    -- Copilot hightlight
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { fg = "#6CC644" })
  end,
  lazy = false,
  priority = 1000,
}

return M
