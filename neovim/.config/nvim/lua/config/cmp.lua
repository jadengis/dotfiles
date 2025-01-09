local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "onsails/lspkind.nvim",
    {
      "hrsh7th/cmp-nvim-lsp",
      event = "InsertEnter",
    },
    {
      "hrsh7th/cmp-buffer",
      event = "InsertEnter",
    },
    {
      "hrsh7th/cmp-path",
      event = "InsertEnter",
    },
    {
      "saadparwaiz1/cmp_luasnip",
      event = "InsertEnter",
    },
    {
      "L3MON4D3/LuaSnip",
      event = "InsertEnter",
    },
    {
      "hrsh7th/cmp-nvim-lua",
    },
    {
      "David-Kunz/cmp-npm",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
  },
}

function M.config()
  local cmp = require "cmp"
  local luasnip = require "luasnip"
  local lspkind = require "lspkind"

  lspkind.init()
  require("cmp-npm").setup({})
  require("luasnip/loaders/from_vscode").lazy_load()

  local check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
  end

  --   פּ ﯟ   some other good icons
  -- local kind_icons = {
  --   Text = "",
  --   Method = "m",
  --   Function = "",
  --   Constructor = "",
  --   Field = "",
  --   Variable = "",
  --   Class = "",
  --   Interface = "",
  --   Module = "",
  --   Property = "",
  --   Unit = "",
  --   Value = "",
  --   Enum = "",
  --   Keyword = "",
  --   Snippet = "",
  --   Color = "",
  --   File = "",
  --   Reference = "",
  --   Folder = "",
  --   EnumMember = "",
  --   Constant = "",
  --   Struct = "",
  --   Event = "",
  --   Operator = "",
  --   TypeParameter = "",
  -- }
  -- find more here: https://www.nerdfonts.com/cheat-sheet

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = {
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
      ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      --[[ ["<Tab>"] = cmp.mapping(function(fallback) ]]
      --[[   if cmp.visible() then ]]
      --[[     cmp.select_next_item() ]]
      --[[   elseif luasnip.expand_or_jumpable() then ]]
      --[[     luasnip.expand_or_jump() ]]
      --[[   elseif check_backspace() then ]]
      --[[     fallback() ]]
      --[[   else ]]
      --[[     fallback() ]]
      --[[   end ]]
      --[[ end, { ]]
      --[[   "i", ]]
      --[[   "s", ]]
      --[[ }), ]]
      --[[ ["<S-Tab>"] = cmp.mapping(function(fallback) ]]
      --[[   if cmp.visible() then ]]
      --[[     cmp.select_prev_item() ]]
      --[[   elseif luasnip.jumpable(-1) then ]]
      --[[     luasnip.jump(-1) ]]
      --[[   else ]]
      --[[     fallback() ]]
      --[[   end ]]
      --[[ end, { ]]
      --[[   "i", ]]
      --[[   "s", ]]
      --[[ }), ]]
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text",
        menu = {
          copilot = "[copilot]",
          codeium = "[codeium]",
          nvim_lsp = "[lsp]",
          nvim_lua = "[api]",
          path = "[path]",
          luasnip = "[snip]",
          buffer = "[buf]",
          npm = "[npm]",
          vim_dadbod_completion = "[db]",
        },
        symbol_map = {
          Copilot = "",
          Codeium = "",
        },
      }),
    },
    sources = {
      { name = "npm", group_index = 1, keyword_length = 4 },
      --[[ { name = "copilot", group_index = 2 }, ]]
      { name = "codeium", group_index = 2 },
      { name = "nvim_lsp", group_index = 2 },
      { name = "neorg", group_index = 2 },
      { name = "path", group_index = 2 },
      { name = "luasnip", group_index = 3 },
      { name = "buffer", group_index = 3 },
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        -- require("copilot_cmp.comparators").prioritize,

        -- Below is the default comparitor list and order for nvim-cmp
        cmp.config.compare.offset,
        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    },
  })

  cmp.setup.filetype({"sql"}, {
    sources = {
      { name = "vim-dadbod-completion" },
      { name = "buffer" },
    }
  })
end

return M
