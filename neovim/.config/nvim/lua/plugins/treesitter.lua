local M = {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  opts = {
    -- parsers to install; tests/bootstrap.lua reads this list too
    parsers = {
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "elixir",
      "eex",
      "heex",
      "erlang",
      "go",
      "c",
      "c_sharp",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown_inline",
      "markdown",
      "bash",
      "json",
      "yaml",
      "xml",
      "toml",
      "sql",
      "csv",
      "python",
      "dockerfile",
      "requirements",
      "gitignore",
      "jinja",
      "embedded_template",
      "ini",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter").install(opts.parsers)

    -- use the markdown parser for mdx files (no dedicated mdx parser exists)
    vim.treesitter.language.register("markdown", "mdx")

    -- Parser names aren't always filetype names (c_sharp -> cs, tsx ->
    -- typescriptreact, bash -> sh, vimdoc -> help), so start treesitter for
    -- every filetype registered to an installed parser.
    local filetypes = {}
    for _, lang in ipairs(opts.parsers) do
      vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
    end

    -- auto-start highlights & indentation
    vim.api.nvim_create_autocmd("FileType", {
      desc = "User: enable treesitter highlighting",
      pattern = filetypes,
      callback = function(ctx)
        -- highlights (folds use vim.treesitter.foldexpr() globally, see options.lua)
        local ok = pcall(vim.treesitter.start)             -- errors for filetypes with no parser
        -- indent
        local no_indent = {}
        if ok and not vim.list_contains(no_indent, ctx.match) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end
}
--[[ local parser_config = require("nvim-treesitter.parsers").get_parser_configs() ]]
--[[ parser_config.markdoc = { ]]
--[[   install_info = { ]]
--[[     url = "https://github.com/markdoc-extra/tree-sitter-markdoc", ]]
--[[     files = { "src/parser.c" }, ]]
--[[     branch = "main", ]]
--[[   }, ]]
--[[   filetype = "markdoc", ]]
--[[ } ]]
return M
