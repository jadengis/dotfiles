-- Resolve debugger command.
local cmd = vim.fn.stdpath("data") .. '/mason/packages/elixir-ls/debugger.sh' -- debugger.bat for windows
local install_path = vim.fn.stdpath("data") .. "/elixir-ls/debugger.sh"
if vim.fn.empty(vim.fn.glob(install_path)) == 0 then
   cmd =  install_path
end

local M = {}
M.adapters = {
  mix_task = {
    type = "executable",
    command = cmd,
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
return M
