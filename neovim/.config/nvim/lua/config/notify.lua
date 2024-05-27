local M = {
  "rcarriga/nvim-notify",
}

function M.config()
  local notify = require("notify")
  notify.setup {
    stages = "fade",
    timeout = 4000,
    top_down = false,
  }
  vim.notify = notify
end

return M
