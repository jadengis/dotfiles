local H = require "tests.helpers"
local eq = H.eq

local child = H.new_child()
local T = MiniTest.new_set({
  hooks = {
    pre_case = function() child.setup() end,
    post_once = child.stop,
  },
})

T["snacks replaces vim.notify, vim.ui.select and vim.ui.input"] = function()
  local sources = child.lua([[
    local function src(fn) return debug.getinfo(fn, "S").source end
    return { notify = src(vim.notify), select = src(vim.ui.select), input = src(vim.ui.input) }
  ]])
  for name, source in pairs(sources) do
    eq({ name, source:find("snacks", 1, true) ~= nil }, { name, true })
  end
end

T["indent scope animation is disabled"] = function()
  eq(child.lua_get "Snacks.config.indent.animate.enabled", false)
end

T["picker opens and closes"] = MiniTest.new_set({
  parametrize = { { "files" }, { "grep" }, { "buffers" }, { "keymaps" }, { "git_status" } },
})

T["picker opens and closes"]["source"] = function(source)
  child.lua("Snacks.picker." .. source .. "()")
  eq(H.wait(child, "#Snacks.picker.get() == 1"), true)
  child.lua "Snacks.picker.get()[1]:close()"
  eq(H.wait(child, "#Snacks.picker.get() == 0"), true)
  vim.uv.sleep(100)
  H.expect_no_errors(child)
end

T["explorer opens as a float"] = function()
  child.lua "Snacks.explorer()"
  eq(H.wait(child, "#Snacks.picker.get({ source = 'explorer' }) == 1"), true)
  eq(child.lua_get "vim.api.nvim_win_get_config(0).relative ~= ''", true)
  vim.uv.sleep(100)
  H.expect_no_errors(child)
end

T["notifications render"] = function()
  child.lua [[vim.notify("hello from tests")]]
  eq(H.wait(child, [[#Snacks.notifier.get_history() > 0]]), true)
  H.expect_no_errors(child)
end

T["expected keymaps exist"] = function()
  local missing = child.lua([[
    local expected = {
      n = {
        " ff", " fg", " fb", " fh", " fr", " ft", " fs", " fd", " fk", " fu", " f.", " fp",
        " e", " gg", " gs", " gc", " gd", " gr", " gB",
        " tf", " uf", " ua", " uh", " ud", " uw",
        " ac", " aa", " db", " dc", " ;", " <Space>",
        "grr", "<S-Q>", "<Esc>", "<C-H>", "<C-L>", "<S-L>", "<S-H>",
      },
      x = { " fw" },
    }
    -- keys = {...} on lazy specs are stubs until first use; maparg still sees them
    local missing = {}
    for mode, lhss in pairs(expected) do
      for _, lhs in ipairs(lhss) do
        if vim.fn.maparg(vim.keycode(lhs), mode) == "" and vim.fn.maparg(lhs, mode) == "" then
          table.insert(missing, mode .. " " .. lhs)
        end
      end
    end
    return missing
  ]])
  eq(missing, {})
end

T["<Esc> clears search highlighting"] = function()
  child.lua [[vim.fn.setline(1, { "foo bar foo" })]]
  child.type_keys "/foo<CR>"
  eq(child.lua_get "vim.v.hlsearch", 1)
  child.type_keys "<Esc>"
  eq(child.lua_get "vim.v.hlsearch", 0)
end

return T
