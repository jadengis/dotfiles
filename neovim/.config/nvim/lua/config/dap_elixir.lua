-- ElixirLS debug adapter, installed by mason together with elixir-ls.
local M = {}
M.adapters = {
  mix_task = {
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/bin/elixir-ls-debugger",
    args = {}
  }
}
M.configurations = {
  elixir = {
    {
      type = "mix_task",
      name = "Current Test",
      task = 'test',
      taskArgs = function()
        local name = vim.api.nvim_buf_get_name(0)
        return { "--trace", name }
      end,
      request = "launch",
      startApps = true, -- for Phoenix projects
      projectDir = "${workspaceFolder}",
      requireFiles = function()
        local name = vim.api.nvim_buf_get_name(0)
        return {
          "test/**/test_helper.exs",
          name,
        }

      end
    },
  }
}

-- ElixirLS advertises exception breakpoint filters but then rejects
-- setExceptionBreakpoints, which nvim-dap reports as an error at the start of
-- every session. Drop the capability so the request isn't sent.
function M.setup(dap)
  dap.listeners.after.initialize.elixir_ls = function(session)
    if session.config.type == "mix_task" then
      session.capabilities.exceptionBreakpointFilters = nil
    end
  end
end

return M
