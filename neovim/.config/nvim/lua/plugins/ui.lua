local M = {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    -- Keymap hints and <leader> group names.
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "quickfix" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>r", group = "refactor" },
        { "<leader>t", group = "tools" },
        { "<leader>u", group = "toggles" },
        { "gr", group = "lsp" },
      },
    },
    keys = {
      { "<leader>K", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },
  {
    -- Breadcrumbs in the winbar (LSP + treesitter, clickable). <leader>; to pick a crumb.
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>;", function() require("dropbar.api").pick() end, desc = "Pick breadcrumb" },
    },
    opts = {},
  },
  {
    -- Inline color swatches for files without an LSP that reports colors.
    -- cssls and tailwindcss already do this natively (LSP document color).
    "brenoprata10/nvim-highlight-colors",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "lua" },
    opts = {
      render = "background",
      enable_tailwind = false,
      exclude_filetypes = {},
    },
  },
}

return M
