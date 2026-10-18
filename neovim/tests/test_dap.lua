local H = require "tests.helpers"
local eq = H.eq

local child = H.new_child()
local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      child.setup()
      child.lua [[require("lazy").load({ plugins = { "nvim-dap" } })]]
    end,
    post_once = child.stop,
  },
})

T["loads without errors or deprecation warnings"] = function()
  H.expect_no_errors(child)
  eq(H.deprecations(child), {})
end

T["elixir adapter uses mason's debugger"] = function()
  eq(child.lua_get [[require("dap").adapters.mix_task.command:match("/mason/bin/elixir%-ls%-debugger$") ~= nil]], true)
  eq(child.lua_get [[require("dap").configurations.elixir[1].name]], "Current Test")
end

T["elixir sessions skip unsupported exception breakpoints"] = function()
  local filters = child.lua([[
    local listener = require("dap").listeners.after.initialize.elixir_ls
    local elixir = { config = { type = "mix_task" }, capabilities = { exceptionBreakpointFilters = { {} } } }
    local other = { config = { type = "python" }, capabilities = { exceptionBreakpointFilters = { {} } } }
    listener(elixir)
    listener(other)
    return { elixir.capabilities.exceptionBreakpointFilters == nil, other.capabilities.exceptionBreakpointFilters ~= nil }
  ]])
  eq(filters, { true, true })
end

T["js-debug adapter runs mason's js-debug-adapter as a server"] = function()
  local adapter = child.lua_get [[require("dap").adapters["pwa-node"] ]]
  eq(adapter.type, "server")
  eq(adapter.executable.command:match("/mason/bin/js%-debug%-adapter$") ~= nil, true)
  eq(child.lua_get [[vim.list_contains(require("config.lsp").tools, "js-debug-adapter")]], true)
end

T["javascript/typescript configurations"] = MiniTest.new_set({
  parametrize = { { "javascript" }, { "typescript" }, { "javascriptreact" }, { "typescriptreact" } },
})

T["javascript/typescript configurations"]["for"] = function(filetype)
  local names = child.lua_get(([[vim.tbl_map(function(c) return c.name end, require("dap").configurations.%s)]]):format(filetype))
  eq(names, {
    "Launch file",
    "Launch file (tsx)",
    "Run npm script",
    "Debug test file (vitest)",
    "Debug test file (jest)",
    "Debug test file (node --test)",
    "Attach to node process",
    "Attach to port 9229 (node --inspect)",
  })
  eq(child.lua_get(([[vim.iter(require("dap").configurations.%s):all(function(c) return c.type == "pwa-node" end)]]):format(filetype)), true)
end

-- VS Code launch.json files use "type": "node"
T["node adapter maps to js-debug"] = function()
  local result = child.lua([[
    local dap = require("dap")
    local config = { type = "node", request = "launch" }
    local got
    dap.adapters.node(function(adapter) got = adapter end, config)
    return { config.type, got == dap.adapters["pwa-node"] }
  ]])
  eq(result, { "pwa-node", true })
end

T["tsx resolves to the project's node_modules first"] = function()
  local project = H.tmpdir({ ["node_modules/.bin/tsx"] = "#!/bin/sh" })
  vim.fn.setfperm(project .. "/node_modules/.bin/tsx", "rwxr-xr-x")
  local resolve = [[require("dap").configurations.typescript[2].runtimeExecutable()]]
  eq(child.lua_get(resolve), "tsx")
  child.cmd("cd " .. project)
  eq(child.lua_get(resolve), project .. "/node_modules/.bin/tsx")
end

T[".vscode/launch.json configurations are offered"] = function()
  local project = H.tmpdir({
    [".vscode/launch.json"] = vim.json.encode({
      version = "0.2.0",
      configurations = { { type = "mix_task", request = "launch", name = "From launch.json", task = "test" } },
    }),
    ["lib/app.ex"] = "defmodule App do\nend",
  })
  child.cmd("cd " .. project)
  child.cmd "edit lib/app.ex"
  local names = child.lua([[
    local dap = require("dap")
    local names = {}
    for _, provider in pairs(dap.providers.configs) do
      for _, config in ipairs(provider(0)) do table.insert(names, config.name) end
    end
    table.sort(names)
    return names
  ]])
  eq(names, { "Current Test", "From launch.json" })
end

T["dap-ui opens with sessions and closes when they end"] = function()
  local listeners = child.lua([[
    local l = require("dap").listeners
    return {
      type(l.before.attach.dapui_config), type(l.before.launch.dapui_config),
      type(l.before.event_terminated.dapui_config), type(l.before.event_exited.dapui_config),
    }
  ]])
  eq(listeners, { "function", "function", "function", "function" })
end

T["dap-ui opens and closes"] = function()
  local before = child.lua_get "#vim.api.nvim_list_wins()"
  child.lua [[require("dapui").open()]]
  eq(child.lua_get("#vim.api.nvim_list_wins() > " .. before), true)
  child.lua [[require("dapui").close()]]
  eq(child.lua_get "#vim.api.nvim_list_wins()", before)
  H.expect_no_errors(child)
end

T["signs have icons"] = MiniTest.new_set({
  parametrize = { { "DapBreakpoint" }, { "DapBreakpointRejected" }, { "DapBreakpointCondition" }, { "DapLogPoint" }, { "DapStopped" } },
})

T["signs have icons"]["sign"] = function(name)
  local text = child.lua_get(("vim.fn.sign_getdefined(%q)[1].text"):format(name))
  eq(type(text) == "string" and vim.fn.strdisplaywidth(text) > 0, true)
end

T["breakpoints can be set"] = function()
  child.cmd("edit " .. H.tmpdir({ ["app.ex"] = "defmodule App do\n  def go, do: :ok\nend" }) .. "/app.ex")
  child.lua [[vim.api.nvim_win_set_cursor(0, { 2, 0 }); require("dap").toggle_breakpoint()]]
  eq(child.lua_get [[#(require("dap.breakpoints").get()[vim.api.nvim_get_current_buf()] or {})]], 1)
end

T["signs and stopped-line highlight are defined"] = function()
  eq(child.lua_get [[vim.fn.sign_getdefined("DapBreakpoint")[1].texthl]], "DiagnosticSignError")
  eq(child.lua_get [[vim.fn.sign_getdefined("DapStopped")[1].linehl]], "DapStoppedLine")
  eq(child.lua_get [[vim.api.nvim_get_hl(0, { name = "DapStoppedLine" }).link]], "Visual")
  child.cmd "colorscheme vscode"
  eq(child.lua_get [[vim.api.nvim_get_hl(0, { name = "DapStoppedLine" }).link]], "Visual")
end

T["keymaps"] = function()
  local missing = child.lua([[
    local missing = {}
    for _, lhs in ipairs({ " db", " dB", " dL", " dc", " dC", " di", " do", " dO", " dr", " dl", " du", " dt", " ?" }) do
      if vim.fn.maparg(lhs, "n") == "" then table.insert(missing, lhs) end
    end
    return missing
  ]])
  eq(missing, {})
end

return T
