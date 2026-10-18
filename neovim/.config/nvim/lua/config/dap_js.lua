-- JavaScript / TypeScript debugging with vscode-js-debug (the engine behind VS
-- Code's debugger), installed by mason as js-debug-adapter.
--
-- TypeScript: Node >= 22.18 strips types natively, so "Launch file" runs .ts
-- files directly and breakpoints line up without source maps. Use "Launch
-- file (tsx)" for TS that needs transpiling (enums, decorators, parameter
-- properties). Compiled projects map back to the .ts sources via source maps.

-- project-local binary, falling back to one on PATH
local function project_bin(name)
  return function()
    local local_bin = vim.fn.getcwd() .. "/node_modules/.bin/" .. name
    return vim.fn.executable(local_bin) == 1 and local_bin or name
  end
end

-- settings shared by every configuration
local function config(opts)
  return vim.tbl_extend("force", {
    type = "pwa-node",
    cwd = "${workspaceFolder}",
    -- step over Node internals and dependencies
    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
  }, opts)
end

local configurations = {
  config({
    name = "Launch file",
    request = "launch",
    program = "${file}",
  }),
  config({
    name = "Launch file (tsx)",
    request = "launch",
    program = "${file}",
    runtimeExecutable = project_bin("tsx"),
  }),
  config({
    name = "Run npm script",
    request = "launch",
    runtimeExecutable = "npm",
    runtimeArgs = function()
      -- a coroutine lets the prompt use vim.ui.input (snacks); empty input aborts
      return coroutine.create(function(dap_run_co)
        vim.ui.input({ prompt = "npm script: " }, function(script)
          local dap = require("dap")
          coroutine.resume(dap_run_co, (script and script ~= "") and { "run", script } or dap.ABORT)
        end)
      end)
    end,
    console = "integratedTerminal",
  }),
  config({
    name = "Debug test file (vitest)",
    request = "launch",
    program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
    args = { "run", "${file}" },
    autoAttachChildProcesses = true,
    console = "integratedTerminal",
  }),
  config({
    name = "Debug test file (jest)",
    request = "launch",
    program = "${workspaceFolder}/node_modules/jest/bin/jest.js",
    args = { "--runInBand", "${file}" },
    console = "integratedTerminal",
  }),
  config({
    name = "Debug test file (node --test)",
    request = "launch",
    program = "${file}",
    runtimeArgs = { "--test" },
    console = "integratedTerminal",
  }),
  config({
    name = "Attach to node process",
    request = "attach",
    processId = function()
      return require("dap.utils").pick_process({ filter = "node" })
    end,
  }),
  config({
    name = "Attach to port 9229 (node --inspect)",
    request = "attach",
    port = 9229,
  }),
}

local M = {}
M.adapters = {
  ["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
      args = { "${port}" },
    },
  },
}
M.configurations = {
  javascript = configurations,
  typescript = configurations,
  javascriptreact = configurations,
  typescriptreact = configurations,
}

function M.setup(dap)
  -- launch.json files written for VS Code use "type": "node"; js-debug calls it pwa-node
  dap.adapters.node = function(callback, config)
    config.type = "pwa-node"
    callback(dap.adapters["pwa-node"])
  end
end

return M
