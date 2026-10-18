local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Don't continue comments on new lines. This has to run on FileType because
-- ftplugins reset 'formatoptions' after init.lua runs.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function()
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
})

-- Reload files changed outside of neovim (e.g. by AI agents) when the cursor
-- stops moving, a buffer is entered, or the terminal regains focus.
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "FocusGained", "BufEnter" }, {
  group = group,
  callback = function()
    if vim.api.nvim_get_mode().mode ~= "c" then
      vim.cmd [[checktime]]
    end
  end,
})
