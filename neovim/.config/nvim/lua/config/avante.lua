local M = {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  opts = {
    provider = "claude",
    auto_suggestions_provider = "copilot",
    behaviour = {
      auto_suggestions = false,
    },
    mappings = {
      suggestion = {
        accept = "<Tab>"
      }
    },
    file_selector = {
      provider = 'telescope',
      provider_opts = {
        hidden = true,
      }
    }
  },
  build = "make", -- This is optional, recommended tho. Also note that this will block the startup for a bit since we are compiling bindings in Rust.
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to setup it properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "markdoc", "Avante" },
      },
      ft = { "markdown", "markdoc", "Avante" },
    },
  },
}
return M
