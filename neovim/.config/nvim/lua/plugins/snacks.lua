-- folke/snacks.nvim: picker, explorer, notifier, input, indent guides and a
-- collection of small QoL modules. See :checkhealth snacks.
local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },      -- disable heavy features on huge files
    quickfile = { enabled = true },    -- render `nvim file` before plugins load
    notifier = { enabled = true, timeout = 4000, top_down = false },
    input = { enabled = true },        -- vim.ui.input
    indent = { enabled = true },       -- indent guides + current scope
    scope = { enabled = true },        -- ii/ai text objects, [i/]i jumps
    words = { enabled = true },        -- highlight LSP references, ]]/[[ to jump
    statuscolumn = { enabled = true },
    explorer = { enabled = true, replace_netrw = true },
    lazygit = { enabled = true },
    picker = {
      enabled = true,
      ui_select = true,                -- vim.ui.select
      win = {
        input = {
          keys = {
            ["<C-x>"] = { "edit_split", mode = { "i", "n" } }, -- telescope muscle memory
          },
        },
      },
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        buffers = {
          win = {
            input = {
              keys = {
                ["<S-q>"] = { "bufdelete", mode = { "n", "i" } },
              },
            },
          },
        },
        explorer = {
          hidden = true,
          auto_close = true,           -- close the float when focus leaves it
          -- centered float, like the old nvim-tree setup
          layout = {
            preview = false,
            layout = {
              backdrop = false,
              width = 0.5,
              min_width = 60,
              height = 0.8,
              box = "vertical",
              border = true,
              title = "{title} {live} {flags}",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
          },
          win = {
            list = {
              keys = {
                ["v"] = "edit_vsplit",
                ["s"] = "edit_split",
              },
            },
          },
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    -- Find
    { "<leader><Space>", function() Snacks.picker.smart() end, desc = "Smart find files" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word/selection", mode = { "n", "x" } },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Find help" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Find recent" },
    { "<leader>ft", function() Snacks.picker.treesitter() end, desc = "Find treesitter symbols" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Find LSP symbols" },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Find workspace symbols" },
    { "<leader>fd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },
    { "<leader>fD", function() Snacks.picker.diagnostics() end, desc = "Workspace diagnostics" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>f:", function() Snacks.picker.command_history() end, desc = "Command history" },
    { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undo history" },
    { "<leader>fq", function() Snacks.picker.qflist() end, desc = "Quickfix list" },
    { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification history" },
    { "<leader>fi", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>f.", function() Snacks.picker.resume() end, desc = "Resume last picker" },
    { "<leader>fR", function() Snacks.rename.rename_file() end, desc = "Rename file (LSP aware)" },

    -- LSP
    { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "<leader>gr", function() Snacks.picker.lsp_references() end, desc = "Find LSP references" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },

    -- Git
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git commits" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git commits (file)" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git diff hunks" },
    { "<leader>gl", function() Snacks.git.blame_line() end, desc = "Git blame line" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git browse (open in browser)", mode = { "n", "x" } },

    -- Explorer / buffers / misc
    { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
    { "<S-q>", function() Snacks.bufdelete() end, desc = "Close buffer (keep window)" },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Close other buffers" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
    { "<leader>x", function() Snacks.scratch() end, desc = "Scratch buffer" },
    { "<leader>X", function() Snacks.scratch.select() end, desc = "Select scratch buffer" },
    { "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
    { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Debug helpers, e.g. :lua dd(vim.lsp.get_clients())
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end

        -- <leader>u: UI toggles (which-key shows their state)
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark background" }):map("<leader>ub")
        Snacks.toggle.new({
          id = "virtual_lines",
          name = "Diagnostic virtual lines",
          get = function() return vim.diagnostic.config().virtual_lines ~= false and vim.diagnostic.config().virtual_lines ~= nil end,
          set = function(state) vim.diagnostic.config({ virtual_lines = state and { current_line = true } or false }) end,
        }):map("<leader>uv")
        Snacks.toggle.new({
          id = "inline_completion",
          name = "Copilot inline completion",
          get = function() return vim.lsp.inline_completion.is_enabled() end,
          set = function(state) vim.lsp.inline_completion.enable(state) end,
        }):map("<leader>ua")
        Snacks.toggle.new({
          id = "autoformat",
          name = "Format on save",
          get = function() return vim.g.autoformat == true end,
          set = function(state) vim.g.autoformat = state end,
        }):map("<leader>uf")
      end,
    })
  end,
}

return M
