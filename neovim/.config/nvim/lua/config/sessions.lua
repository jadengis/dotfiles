local M = {
  "rmagatti/auto-session",
  dependencies = { "nvim-tree/nvim-tree.lua" },
}

function M.config()
  -- Workaround for session buffer
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    pattern = 'NvimTree*',
    callback = function()
      local api = require('nvim-tree.api')

      if not api.tree.is_visible() then
        api.tree.open()
      end
    end,
  })

  require("auto-session").setup {}
end

return M
