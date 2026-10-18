local H = require "tests.helpers"
local eq = H.eq

local child = H.new_child()
local T = MiniTest.new_set({
  hooks = { post_once = child.stop },
})

-- Regression: auto-session restores inside a nested VimEnter, and plugins that
-- lazy-load on BufReadPre used to leave the restored buffer without a filetype
-- (so no treesitter highlighting and no LSP).
T["restored buffer gets filetype and highlighting"] = function()
  local project = H.tmpdir({
    ["src/index.ts"] = "export const answer: number = 42;",
    ["package.json"] = "{}",
  })

  -- auto-session never saves/restores without a UI unless told it's a test
  local env = { AUTOSESSION_UNIT_TESTING = "1" }
  child.setup({ cwd = project, args = { "src/index.ts" }, env = env })
  child.cmd "edit package.json"
  child.cmd "buffer src/index.ts"
  child.cmd "AutoSession save"

  -- start in the project with no file arguments, so auto-session restores
  child.setup({ cwd = project, env = env })
  eq(H.wait(child, [[vim.fn.expand("%:t") == "index.ts"]]), true)
  eq(H.wait(child, [[vim.bo.filetype == "typescript"]]), true)
  eq(child.lua_get "vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil", true)
  H.expect_no_errors(child)

  child.cmd "AutoSession delete"
end

return T
