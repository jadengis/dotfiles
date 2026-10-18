-- Init for the test *runner* process (just test). Only loads mini.test; each
-- test case starts a child Neovim with the real config (see helpers.lua).
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.rtp:prepend(root .. "/.tests/deps/mini.test")
require("mini.test").setup()
