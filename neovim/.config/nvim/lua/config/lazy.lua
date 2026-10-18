local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Every file in lua/plugins/ returns a spec (or a list of specs).
require("lazy").setup {
  spec = {
    { import = "plugins" },
  },
  install = {
    colorscheme = { "vscode", "habamax" },
  },
  ui = {
    border = "rounded",
  },
  checker = {
    enabled = true, -- check for plugin updates in the background
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}
