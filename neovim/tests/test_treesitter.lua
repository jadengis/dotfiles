local H = require "tests.helpers"
local eq = H.eq

local child = H.new_child()
local T = MiniTest.new_set({
  hooks = {
    pre_once = function() child.setup() end,
    post_once = child.stop,
  },
})

T["configured parsers are installed"] = function()
  local missing = child.lua([[
    local spec = require("lazy.core.config").plugins["nvim-treesitter"]
    local parsers = require("lazy.core.plugin").values(spec, "opts", false).parsers
    local installed = require("nvim-treesitter").get_installed()
    return vim.tbl_filter(function(p) return not vim.list_contains(installed, p) end, parsers)
  ]])
  eq(missing, {})
end

-- A parser built from an older nvim-treesitter commit than its queries breaks
-- highlighting (and ui2's cmdline highlighting) with "Invalid node type".
T["queries compile against every installed parser"] = function()
  local broken = child.lua([[
    local broken = {}
    for _, lang in ipairs(require("nvim-treesitter").get_installed()) do
      -- skip query-only languages (ecma, jsx, html_tags) that other parsers inherit
      if not vim.treesitter.language.add(lang) then goto continue end
      for _, kind in ipairs({ "highlights", "injections", "folds", "indents" }) do
        local ok, err = pcall(vim.treesitter.query.get, lang, kind)
        if not ok then
          table.insert(broken, ("%s/%s: %s"):format(lang, kind, tostring(err):match("[^\n]+")))
        end
      end
      ::continue::
    end
    return broken
  ]])
  eq(broken, {})
end

-- Parser names don't always match filetypes (tsx -> typescriptreact, ...).
T["highlighting starts for"] = MiniTest.new_set({
  parametrize = {
    { "a.ts", "typescript" },
    { "a.tsx", "typescriptreact" },
    { "a.js", "javascript" },
    { "a.lua", "lua" },
    { "a.cs", "cs" },
    { "a.sh", "sh" },
    { "a.ex", "elixir" },
    { "a.md", "markdown" },
    { "a.mdx", "mdx" },
    { "a.json", "json" },
    { "a.yaml", "yaml" },
    { "a.uss", "css" },
    { "a.uxml", "xml" },
  },
})

T["highlighting starts for"]["file"] = function(name, filetype)
  local dir = H.tmpdir()
  child.cmd("edit " .. dir .. "/" .. name)
  eq(child.lua_get "vim.bo.filetype", filetype)
  eq(child.lua_get "vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil", true)
  child.cmd "bwipeout!"
end

return T
