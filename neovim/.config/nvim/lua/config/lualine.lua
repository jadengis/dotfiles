local M = {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }
}

function M.config()

  local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = false,
    update_in_insert = false,
    always_visible = true,
  }

  local diff = {
    "diff",
    colored = false,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = hide_in_width
  }

  local mode = {
    "mode",
    fmt = function(str)
      return "-- " .. str .. " --"
    end,
  }

  local filetype = {
    "filetype",
    colored = false,
  }

  local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
  }

  local location = {
    "location",
    padding = 0,
  }

  -- cool function for progress
  local progress = function()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end

  local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end

  require("lualine").setup({
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        "dashboard",
        "Outline",
      },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { mode },
      lualine_b = { branch, diff },
      lualine_c = { diagnostics },
      lualine_x = { spaces },
      lualine_y = { "encoding", filetype },
      lualine_z = { location, progress },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = { "nvim-tree", "nvim-dap-ui", "toggleterm"},
  })
end

return M
