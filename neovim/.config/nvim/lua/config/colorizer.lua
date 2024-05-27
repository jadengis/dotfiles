local M = {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      "css",
      "scss",
      "javascript",
      "typescript",
      "html",
    }, { rgb_fn = true })
  end,
}

return M
