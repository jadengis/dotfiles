-- Formatting with conform.nvim. Falls back to the LSP formatter (e.g. elixirls
-- for mix format) when no formatter is configured for the filetype.
-- Linting comes from language servers (eslint, etc.).
local prettier = { "prettierd", "prettier", stop_after_first = true }

local M = {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>tf",
      function() require("conform").format({ async = true }) end,
      mode = { "n", "x" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = prettier,
      javascriptreact = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      vue = prettier,
      svelte = prettier,
      css = prettier,
      scss = prettier,
      less = prettier,
      html = prettier,
      json = prettier,
      jsonc = prettier,
      yaml = prettier,
      markdown = prettier,
      mdx = prettier,
      graphql = prettier,
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Off by default; toggle with <leader>uf.
    format_on_save = function()
      if vim.g.autoformat then
        return { timeout_ms = 1000 }
      end
    end,
  },
  init = function()
    vim.g.autoformat = false

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
      end
      require("conform").format({ async = true, range = range })
    end, { range = true, desc = "Format buffer or range" })
  end,
}

return M
