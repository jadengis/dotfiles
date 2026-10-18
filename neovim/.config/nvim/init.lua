require "config.options"
require "config.keymaps"
require "config.autocmds"

-- Only load plugins if not in vscode.
if not vim.g.vscode then
  require "config.lazy"
end
