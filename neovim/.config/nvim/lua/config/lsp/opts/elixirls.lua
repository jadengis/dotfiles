local install_path = vim.fn.stdpath("data") .. "/mason/bin/elixir-ls"

local opts = {
  cmd = { install_path },
  breadcrumbs = {
    filetypes = { "elixir" },
  },
}
return opts
