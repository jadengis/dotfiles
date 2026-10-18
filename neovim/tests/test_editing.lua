-- Completion, formatting and other insert/cmdline behaviour.
local H = require "tests.helpers"
local eq = H.eq

local child = H.new_child()
local T = MiniTest.new_set({
  hooks = {
    pre_case = function() child.setup() end,
    post_once = child.stop,
  },
})

-- Regression: blink's cmdline menu used to accept the first item on <CR>
-- instead of running the command as typed.
T["cmdline <CR> runs the command as typed"] = function()
  child.type_keys(":let g:typed = 42", "<CR>")
  eq(child.lua_get "vim.g.typed", 42)
end

T[":w writes with a single <CR>"] = function()
  local dir = H.tmpdir()
  child.cmd("edit " .. dir .. "/out.txt")
  child.type_keys("ihello<Esc>", ":w", "<CR>")
  eq(vim.fn.readfile(dir .. "/out.txt"), { "hello" })
end

T["<Tab> falls back to indenting in insert mode"] = function()
  -- <Tab> chains snippet jump -> sidekick NES -> copilot ghost text -> fallback
  child.cmd("edit " .. H.tmpdir() .. "/a.txt")
  child.type_keys("i", "<Tab>", "x", "<Esc>")
  eq(child.lua_get "vim.api.nvim_get_current_line()", "  x")
  H.expect_no_errors(child)
end

T["insert mode completion shows LSP-less buffer words"] = function()
  child.cmd("edit " .. H.tmpdir() .. "/a.txt")
  child.type_keys("ialphabet<CR>alp")
  eq(H.wait(child, [[require("blink.cmp").is_visible()]]), true)
  child.type_keys "<CR>"
  eq(child.lua_get "vim.api.nvim_get_current_line()", "alphabet")
  H.expect_no_errors(child)
end

T["conform picks the right formatters"] = MiniTest.new_set({
  parametrize = {
    { "a.lua", { "stylua" } },
    { "a.ts", { "prettierd", "prettier" } },
    { "a.json", { "prettierd", "prettier" } },
  },
})

T["conform picks the right formatters"]["for"] = function(name, formatters)
  child.cmd("edit " .. H.tmpdir() .. "/" .. name)
  eq(child.lua_get [[require("conform").list_formatters_for_buffer()]], formatters)
end

T["format on save is off by default"] = function()
  eq(child.lua_get "vim.g.autoformat", false)
  eq(child.lua_get "vim.fn.exists(':Format')", 2)
end

return T
