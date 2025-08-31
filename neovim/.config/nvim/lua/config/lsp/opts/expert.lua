local install_path = vim.fn.expand("$HOME/.local/bin/expert")

local opts = {
  cmd = { install_path },
}
return opts
