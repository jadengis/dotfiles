local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio"
  },
  keys = {
     { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
     { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
     { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step Into" },
     { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step Over" },
     { "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Step Out" },
     { "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Toggle REPL" },
     { "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "Run Last" },
     { "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", desc = "Toggle UI" },
     { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
     { "<leader>?", "<cmd>lua require'dapui'.eval(nil, { enter = true })<cr>", desc = "Evaluate", mode = { "n", "v" } },
  }
}

function M.config()
  local dap = require("dap")
  local dapui = require("dapui")

  local languages = { "elixir" }

  -- Load all adapters
  for _, language in pairs(languages) do
    local has_opts, language_opts = pcall(require, "config.dap.opts." .. language)
    if has_opts then
      for adapter, opts in pairs(language_opts.adapters) do
        dap.adapters[adapter] = opts
      end
      for configuration, opts in pairs(language_opts.configurations) do
        local tbl = dap.configurations[configuration]
        dap.configurations[configuration] = vim.tbl_deep_extend("force", tbl or {}, opts)
      end
    end
  end

  -- Read environmental dap configurations
  require('dap.ext.vscode').load_launchjs(nil, { mix_task = { "elixir" } })

  -- Configure Signs
  vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })

  -- Setup UI
  dapui.setup {}

  -- Event listeners to auto-pop UI
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
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
