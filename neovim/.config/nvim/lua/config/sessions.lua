local module = "auto-session"
local status_ok, auto_session = pcall(require, module)
if not status_ok then
  vim.notify("module named " .. module .. " not found")
  return
end

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

auto_session.setup {}
