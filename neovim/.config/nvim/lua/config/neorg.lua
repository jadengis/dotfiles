local M = {}

M.setup = function()
  local status_ok, neorg = pcall(require, "neorg")
  if not status_ok then
    vim.notify("Neorg not installed", "error", { title = "Neorg" })
    return
  end

  neorg.setup({
    load = {
      ["core.defaults"] = {}, -- Load all the default modules
      ["core.completion"] = {
        config = {
          name = "[neorg]",
          engine = "nvim-cmp",
        },
      },
      ["core.integrations.nvim-cmp"] = {},
      ["core.concealer"] = { config = { icon_preset = "diamond" } }, -- Allows for use of icons
      ["core.export"] = {},
      ["core.keybinds"] = {
        -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
        config = {
          default_keybinds = true,
          neorg_leader = "<Leader><Leader>",
        },
      },
      ["core.esupports.metagen"] = { config = { type = "auto", update_date = true } },
      ["core.qol.toc"] = {},
      ["core.qol.todo_items"] = {},
      ["core.looking-glass"] = {},
      ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
      ["core.journal"] = {
        config = {
          workspace = "personal",
        },
      },
      ["core.dirman"] = { -- Manage your directories with Neorg
        config = {
          workspaces = {
            personal = "~/notes/personal",
          },
          default_workspace = "personal",
        },
      },
    },
  })
end

return M
