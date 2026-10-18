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

-- Session restores (auto-session) run inside a nested VimEnter. Plugins that
-- lazy-load on BufReadPre (lspconfig, gitsigns) re-fire FileType while loading,
-- which sets did_filetype() for the rest of that chain, so `:setf` is skipped
-- for the restored buffer: no filetype, no treesitter, no LSP. Re-detect once
-- the chain has finished.
vim.api.nvim_create_autocmd("SessionLoadPost", {
  group = group,
  callback = function()
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf)
          and vim.bo[buf].buftype == ""
          and vim.bo[buf].filetype == ""
          and vim.api.nvim_buf_get_name(buf) ~= ""
        then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd "filetype detect"
          end)
        end
      end
    end)
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
