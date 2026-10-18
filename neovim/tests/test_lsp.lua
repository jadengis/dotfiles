local H = require "tests.helpers"
local eq = H.eq

local child = H.new_child()
local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      child.setup()
      -- nvim-lspconfig (and config.lsp) load on BufReadPre
      child.lua [[require("lazy").load({ plugins = { "nvim-lspconfig" } })]]
    end,
    post_once = child.stop,
  },
})

T["every configured server is enabled with a command"] = function()
  local problems = child.lua([[
    local problems = {}
    for _, name in ipairs(require("config.lsp").servers) do
      local config = vim.lsp.config[name]
      if not vim.lsp.is_enabled(name) then table.insert(problems, name .. ": not enabled") end
      if not config or not config.cmd then table.insert(problems, name .. ": no cmd") end
    end
    return problems
  ]])
  eq(problems, {})
end

T["after/lsp overrides are merged"] = function()
  eq(child.lua_get [[vim.lsp.config.cssls.settings.css.lint.unknownAtRules]], "ignore")
  eq(child.lua_get [[vim.lsp.config.ts_ls.workspace_required]], true)
  eq(child.lua_get [[vim.lsp.config.ts_ls.init_options.maxTsServerMemory]], 16384)
  eq(child.lua_get [[vim.lsp.config.ts_ls.init_options.hostInfo]], "neovim") -- lspconfig default kept
  eq(child.lua_get [[#vim.lsp.config.jsonls.settings.json.schemas > 100]], true) -- SchemaStore
  eq(child.lua_get [[vim.lsp.config.roslyn_ls.settings["csharp|background_analysis"].dotnet_analyzer_diagnostics_scope]], "openFiles")
  eq(child.lua_get [[vim.lsp.config.html.settings.html.format.enable]], false)
end

T["completion capabilities come from blink.cmp"] = function()
  eq(child.lua_get [[vim.lsp.config["*"].capabilities.textDocument.completion.completionItem.snippetSupport]], true)
end

-- Attach an in-process fake server to exercise the LspAttach path.
T["LspAttach sets buffer keymaps"] = function()
  child.lua([[
    vim.cmd.edit(vim.fn.tempname() .. ".txt")
    local buf = vim.api.nvim_get_current_buf()
    vim.lsp.start({
      name = "fake",
      cmd = function(dispatchers)
        local closing = false
        return {
          request = function(method, _, callback)
            if method == "initialize" then
              callback(nil, { capabilities = { definitionProvider = true, codeActionProvider = true } })
            elseif method == "shutdown" then
              callback(nil, nil)
            end
            return true, 1
          end,
          notify = function() return true end,
          is_closing = function() return closing end,
          terminate = function() closing = true end,
        }
      end,
    }, { bufnr = buf })
  ]])
  eq(H.wait(child, [[#vim.lsp.get_clients({ bufnr = 0, name = "fake" }) == 1]]), true)

  local maps = child.lua([[
    local found = {}
    for _, lhs in ipairs({ "gd", "gD", "gi", "gl", "<S-J>", " rn", " .", " q" }) do
      found[lhs] = vim.fn.maparg(lhs, "n", false, true).buffer == 1
    end
    return found
  ]])
  for lhs, ok in pairs(maps) do
    eq({ lhs, ok }, { lhs, true })
  end
  H.expect_no_errors(child)
end

T["copilot inline completion is enabled"] = function()
  eq(child.lua_get "vim.lsp.inline_completion.is_enabled()", true)
end

return T
