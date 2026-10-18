-- Debugging with nvim-dap + nvim-dap-ui.
-- Projects' .vscode/launch.json files are read automatically when a session
-- starts (:help dap-providers), so no loading step is needed here.
local function prompt(text, fn)
  vim.ui.input({ prompt = text }, function(value)
    if value and value ~= "" then
      fn(value)
    end
  end)
end

local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
  },
  keys = {
     { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
     { "<leader>dB", function() prompt("Breakpoint condition: ", function(c) require("dap").set_breakpoint(c) end) end, desc = "Conditional Breakpoint" },
     { "<leader>dL", function() prompt("Log message: ", function(m) require("dap").set_breakpoint(nil, nil, m) end) end, desc = "Log Point" },
     { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
     { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
     { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step Into" },
     { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step Over" },
     { "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Step Out" },
     { "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Toggle REPL" },
     { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
     { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
     { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
     { "<leader>?", function() require("dapui").eval(nil, { enter = true }) end, desc = "Evaluate", mode = { "n", "v" } },
  }
}

function M.config()
  local dap = require("dap")
  local dapui = require("dapui")

  -- Load all adapters
  local languages = {
    elixir = require("config.dap_elixir"),
    javascript = require("config.dap_js"), -- also typescript and react
  }
  for _, language_opts in pairs(languages) do
    for adapter, opts in pairs(language_opts.adapters) do
      dap.adapters[adapter] = opts
    end
    for configuration, opts in pairs(language_opts.configurations) do
      local tbl = dap.configurations[configuration]
      dap.configurations[configuration] = vim.list_extend(tbl or {}, opts)
    end
    if language_opts.setup then
      language_opts.setup(dap)
    end
  end

  -- Configure Signs
  local function stopped_line_hl()
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
  end
  stopped_line_hl()
  vim.api.nvim_create_autocmd("ColorScheme", { callback = stopped_line_hl })
  local signs = {
    DapBreakpoint = { text = "", texthl = "DiagnosticSignError" },
    DapBreakpointRejected = { text = "", texthl = "DiagnosticSignError" },
    DapBreakpointCondition = { text = "", texthl = "DiagnosticSignError" },
    DapLogPoint = { text = "", texthl = "DiagnosticSignHint" },
    DapStopped = { text = "", texthl = "DiagnosticSignHint", linehl = "DapStoppedLine" },
  }
  for name, sign in pairs(signs) do
    vim.fn.sign_define(name, sign)
  end

  -- Setup UI
  dapui.setup {}

  -- Open the UI when a session starts and close it when it ends
  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
  end
end

return M
