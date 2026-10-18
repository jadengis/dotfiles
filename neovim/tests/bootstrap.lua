-- Prepares neovim/.tests/ for the test suite (run by `make test-deps`):
-- installs every plugin at the commit pinned in lazy-lock.json and builds the
-- configured treesitter parsers. Runs with the real config loaded:
--   nvim --headless -c "luafile tests/bootstrap.lua"
local function fail(msg)
  io.stderr:write("bootstrap: " .. msg .. "\n")
  vim.cmd "cquit 1"
end

local ok, err = pcall(function()
  -- lazy.nvim can't restore itself, so check out its locked commit directly.
  local Config = require "lazy.core.config"
  local lock = vim.json.decode(table.concat(vim.fn.readfile(Config.options.lockfile), "\n"))
  local lazy_dir, commit = Config.plugins["lazy.nvim"].dir, lock["lazy.nvim"].commit
  if vim.system({ "git", "-C", lazy_dir, "checkout", "--quiet", commit }):wait().code ~= 0 then
    vim.system({ "git", "-C", lazy_dir, "fetch", "--quiet", "origin", commit }):wait()
    assert(vim.system({ "git", "-C", lazy_dir, "checkout", "--quiet", commit }):wait().code == 0,
      "could not check out lazy.nvim " .. commit)
  end

  local lazy = require "lazy"
  lazy.install({ wait = true, show = false })
  lazy.restore({ wait = true, show = false })
  lazy.clean({ wait = true, show = false })

  local spec = require("lazy.core.config").plugins["nvim-treesitter"]
  local parsers = require("lazy.core.plugin").values(spec, "opts", false).parsers
  local ts = require "nvim-treesitter"
  -- install() is a no-op for parsers that are already built; update()
  -- rebuilds parsers whose revision changed with the nvim-treesitter commit.
  ts.install(parsers):wait(600000)
  ts.update():wait(600000)

  local installed = ts.get_installed()
  local missing = vim.tbl_filter(function(p) return not vim.list_contains(installed, p) end, parsers)
  assert(#missing == 0, "treesitter parsers failed to install: " .. table.concat(missing, ", "))
end)

if not ok then
  fail(tostring(err))
else
  vim.cmd "qall!"
end
