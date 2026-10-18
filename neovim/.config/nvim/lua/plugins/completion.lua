local M = {
  "saghen/blink.cmp",
  version = "1.*", -- v2 is in development with breaking changes
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "rafamadriz/friendly-snippets", -- vscode-style snippets, expanded with native vim.snippet
  },
  opts = {
    keymap = {
      preset = "enter", -- <CR> accepts the selected (or first) item
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "cancel", "fallback" },
      ["<Tab>"] = {
        "snippet_forward",
        function() -- sidekick next edit suggestion
          return require("sidekick").nes_jump_or_apply()
        end,
        function() -- copilot ghost text (native LSP inline completion)
          return vim.lsp.inline_completion.get()
        end,
        "fallback",
      },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      list = { selection = { preselect = true, auto_insert = false } },
    },
    signature = { enabled = true },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        sql = { "dadbod", "buffer" },
        lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        dadbod = { name = "DB", module = "vim_dadbod_completion.blink" },
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },
    cmdline = {
      -- <CR> always runs the command as typed; <Tab> completes, <C-y> accepts.
      keymap = { preset = "cmdline" },
      completion = {
        list = { selection = { preselect = false } },
        -- stay out of the way for short commands like :w and :qa
        menu = {
          auto_show = function()
            return vim.fn.getcmdtype() == ":" and #vim.fn.getcmdline() >= 3
          end,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}

return M
