-- Firebase security rules (firestore.rules, storage.rules): Vim syntax
-- highlighting and commentstring. Only loads once a firestore buffer opens;
-- options.lua detects the filetype.
local M = {
  "delphinus/vim-firestore",
  -- Not `ft`: lazy.nvim sources an `ft` plugin's ftdetect at startup, and this
  -- one forces every *.rules file (udev, polkit) to firestore.
  event = "FileType firestore",
  config = function()
    -- Loading sources that ftdetect anyway, so drop its autocmd again.
    vim.api.nvim_clear_autocmds({
      group = "filetypedetect",
      event = { "BufNewFile", "BufRead" },
      pattern = "*.rules",
    })
  end,
}

return M
