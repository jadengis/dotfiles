-- Init for the child Neovim that runs the real config under test.
--
-- mini.test always starts children with --clean, which drops the user config
-- and data dirs from 'runtimepath', so put them back before sourcing init.lua.
-- The XDG_* variables set by `make test` point stdpath() at neovim/.tests/.
local config = vim.fn.stdpath("config")
local site = vim.fn.stdpath("data") .. "/site"

vim.opt.rtp:prepend(config)
vim.opt.rtp:prepend(site)
vim.opt.rtp:append(config .. "/after")
vim.opt.packpath:prepend(site)

-- Children are spawned by the runner, which sets $NVIM. Clear it so the config
-- behaves like a top-level instance (auto-session skips nested instances).
vim.env.NVIM = nil

-- Lets a test start the child inside a project directory (e.g. for sessions).
if vim.env.NVIM_TEST_CWD then
  vim.cmd.cd(vim.env.NVIM_TEST_CWD)
end

dofile(config .. "/init.lua")
