-- Shared helpers for the config test suite.
local H = {}

H.root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
H.eq = MiniTest.expect.equality

--- A child Neovim that loads the real config.
---@return MiniTest.child
function H.new_child()
  local child = MiniTest.new_child_neovim()

  --- Start (or restart) the child.
  ---@param opts? { cwd?: string, args?: string[], env?: table<string,string>, ui?: boolean }
  ---  cwd: directory to start in. args: extra nvim arguments (e.g. files).
  ---  env: extra environment variables for the child.
  ---  ui: fire UIEnter so VeryLazy plugins load, like a real TUI (default true).
  function child.setup(opts)
    opts = opts or {}
    -- the child inherits the runner's environment
    local env = vim.tbl_extend("force", { NVIM_TEST_CWD = opts.cwd }, opts.env or {})
    for k, v in pairs(env) do vim.env[k] = v end
    local args = { "-u", H.root .. "/tests/child_init.lua" }
    vim.list_extend(args, opts.args or {})
    child.restart(args, { connection_timeout = 10000 })
    for k in pairs(env) do vim.env[k] = nil end
    if opts.ui ~= false then
      child.ui_enter()
    end
  end

  --- Fire UIEnter, which lazy.nvim uses to trigger the VeryLazy event.
  function child.ui_enter()
    child.cmd "doautocmd UIEnter"
    -- which-key is a VeryLazy plugin, so once it's loaded VeryLazy has run
    H.wait(child, [[package.loaded["which-key"] ~= nil]], 5000)
  end

  return child
end

--- Poll a Lua expression in the child until it is truthy.
---@param child MiniTest.child
---@param expr string
---@param timeout? integer ms (default 5000)
---@return boolean
function H.wait(child, expr, timeout)
  return vim.wait(timeout or 5000, function()
    local ok, res = pcall(child.lua_get, expr)
    return ok and res and true or false
  end, 25)
end

--- Errors reported so far in the child: error messages in :messages and
--- error-level notifications (snacks notifier history).
---@param child MiniTest.child
---@return string[]
function H.errors(child)
  return child.lua([[
    local errs = {}
    local messages = vim.api.nvim_exec2("messages", { output = true }).output
    for _, line in ipairs(vim.split(messages, "\n")) do
      if line:match("E%d+:") or line:match("Error") or line:match("^Lua:") then
        table.insert(errs, line)
      end
    end
    local ok, Snacks = pcall(require, "snacks")
    if ok and Snacks.notifier and Snacks.config.notifier.enabled then
      for _, n in ipairs(Snacks.notifier.get_history({ filter = "error" })) do
        table.insert(errs, ("[%s] %s"):format(n.title or "notify", n.msg))
      end
    end
    return errs
  ]])
end

--- Assert that the child has reported no errors.
---@param child MiniTest.child
function H.expect_no_errors(child)
  local errs = H.errors(child)
  if #errs > 0 then
    error("Neovim reported errors:\n  " .. table.concat(errs, "\n  "), 2)
  end
end

--- Create a temporary directory with the given files ({ [path] = content }).
---@param files? table<string, string>
---@return string dir
function H.tmpdir(files)
  local dir = vim.fn.tempname()
  vim.fn.mkdir(dir, "p")
  for path, content in pairs(files or {}) do
    local file = dir .. "/" .. path
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":h"), "p")
    vim.fn.writefile(vim.split(content, "\n"), file)
  end
  return dir
end

return H
