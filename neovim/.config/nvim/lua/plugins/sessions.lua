local M = {
  "rmagatti/auto-session",
  lazy = false, -- must load at startup to restore the session
  keys = {
    { "<leader>fp", "<cmd>AutoSession search<cr>", desc = "Find session" },
  },
  opts = {
    session_lens = {
      picker = "snacks",
    },
  },
}

return M
