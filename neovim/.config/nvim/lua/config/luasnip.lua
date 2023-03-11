local module = "luasnip"
local status_ok, luasnip = pcall(require, module)
if not status_ok then
  vim.notify("Module " .. module .. " not found", vim.log.levels.ERROR)
  return
end

local unlinkgrp = vim.api.nvim_create_augroup(
  'UnlinkSnippetOnModeChange',
  { clear = true }
)

vim.api.nvim_create_autocmd('ModeChanged', {
  group = unlinkgrp,
  pattern = {'s:n', 'i:*'},
  desc = 'Forget the current snippet when leaving the insert mode',
  callback = function(evt)
    if
      luasnip.session
      and luasnip.session.current_nodes[evt.buf]
      and not luasnip.session.jump_active
    then
      luasnip.unlink_current()
    end
  end,
})
