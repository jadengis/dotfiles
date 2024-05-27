local M = {
  "utilyre/barbecue.nvim",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
    "neovim/nvim-lspconfig"
  },
}

function M.config()
  require("barbecue").setup({ attach_navic = false })
end

return M
