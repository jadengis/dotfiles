local H = require "tests.helpers"
local eq = H.eq

local child = H.new_child()
local T = MiniTest.new_set({
  hooks = {
    pre_case = function() child.setup() end,
    post_once = child.stop,
  },
})

T["starts without errors"] = function()
  H.expect_no_errors(child)
  eq(child.lua_get "Snacks ~= nil", true)
end

T["installed plugins match lazy-lock.json"] = function()
  -- compare against the repo's lockfile (the sandbox works on a copy)
  local mismatches = child.lua([[
    local Config = require("lazy.core.config")
    local Git = require("lazy.manage.git")
    local lock = vim.json.decode(table.concat(vim.fn.readfile(...), "\n"))
    local bad = {}
    for name, plugin in pairs(Config.plugins) do
      local info = Git.info(plugin.dir)
      if not lock[name] then
        table.insert(bad, name .. ": missing from lazy-lock.json")
      elseif not info or info.commit ~= lock[name].commit then
        table.insert(bad, ("%s: installed %s, locked %s"):format(name, info and info.commit or "nothing", lock[name].commit))
      end
    end
    for name in pairs(lock) do
      if not Config.plugins[name] then
        table.insert(bad, name .. ": in lazy-lock.json but not in the spec")
      end
    end
    table.sort(bad)
    return bad
  ]], { H.root .. "/.config/nvim/lazy-lock.json" })
  eq(mismatches, {})
end

T["every plugin loads without errors"] = function()
  local not_loaded = child.lua([[
    local Config = require("lazy.core.config")
    require("lazy").load({ plugins = vim.tbl_keys(Config.plugins) })
    local missing = {}
    for name, plugin in pairs(Config.plugins) do
      if not plugin._.loaded then table.insert(missing, name) end
    end
    return missing
  ]])
  eq(not_loaded, {})
  H.expect_no_errors(child)
end

T["lazy.nvim health check has no errors"] = function()
  child.cmd "checkhealth lazy"
  local errors = child.lua([[
    return vim.tbl_filter(function(l) return l:match("ERROR") ~= nil end, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  ]])
  eq(errors, {})
end

T["core options"] = function()
  eq(child.lua_get "vim.o.winborder", "rounded")
  eq(child.lua_get "vim.o.foldexpr", "v:lua.vim.treesitter.foldexpr()")
  eq(child.lua_get "vim.o.clipboard", "unnamedplus")
  eq(child.lua_get "vim.o.statuscolumn:find('snacks') ~= nil", true)
  eq(child.lua_get "vim.g.mapleader", " ")
end

T["diagnostic signs use custom icons"] = function()
  -- sign_define() no longer configures diagnostic signs on 0.12
  eq(child.lua_get "#vim.tbl_keys(vim.diagnostic.config().signs.text)", 4)
end

T["formatoptions drop comment continuation"] = function()
  child.cmd "edit tests/helpers.lua"
  eq(child.lua_get "vim.bo.formatoptions:find('[cro]') == nil", true)
end

return T
