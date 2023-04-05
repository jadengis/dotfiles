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
      ["core.norg.journal"] = {
        config = {
          workspace = "personal"
        }
      },
      ["core.norg.concealer"] = {}, -- Allows for use of icons
      ["core.norg.completion"] = {
        config = {
          name = "[neorg]",
          engine = "nvim-cmp",
        },
      },
      ["core.norg.dirman"] = { -- Manage your directories with Neorg
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
