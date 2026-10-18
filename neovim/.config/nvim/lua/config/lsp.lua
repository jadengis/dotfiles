-- Native LSP setup (Neovim 0.11+).
--
-- Per-server overrides live in after/lsp/<server>.lua and are merged on top of
-- nvim-lspconfig's lsp/<server>.lua automatically by vim.lsp.config().
--
-- Neovim already provides these LSP keymaps by default, so they aren't mapped here:
--   K hover, grn rename, gra code action, grr references, gri implementation,
--   grt type definition, grx codelens, gO document symbols, <C-s> signature help (insert),
--   [d / ]d previous/next diagnostic, an / in incremental selection (visual)
local M = {}

-- Servers installed through mason and enabled at startup.
M.servers = {
  "ts_ls",
  "eslint",
  "jsonls",
  "html",
  "cssls",
  "tailwindcss",
  "elixirls",
  "lua_ls",
  "texlab",
  "sqlls",
  "copilot", -- inline completion + sidekick next-edit suggestions
}

-- Formatters and other non-LSP tools installed through mason.
M.tools = {
  "stylua",
  "prettierd",
}

local function diagnostics()
  local severity = vim.diagnostic.severity
  vim.diagnostic.config({
    virtual_text = true,
    signs = {
      text = {
        [severity.ERROR] = "",
        [severity.WARN] = "",
        [severity.HINT] = "",
        [severity.INFO] = "",
      },
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      source = true,
      header = "",
      prefix = "",
    },
  })
end

local function keymaps(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buf = bufnr, silent = true, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Goto definition")
  map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
  map("n", "gl", vim.diagnostic.open_float, "Line diagnostics")
  map("n", "<S-j>", vim.lsp.buf.signature_help, "Signature help")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  map({ "n", "x" }, "<leader>.", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics to loclist")
end

local function inline_completion()
  -- Ghost-text suggestions from the copilot language server. <Tab> accepts
  -- (see the blink.cmp keymap in plugins/completion.lua).
  vim.lsp.inline_completion.enable()
end

function M.setup()
  diagnostics()

  for _, server in ipairs(M.servers) do
    vim.lsp.enable(server)
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(ev)
      keymaps(ev.buf)
    end,
  })

  inline_completion()
end

return M
