local M = {
  "nvim-treesitter/nvim-treesitter",
  --[[ dependencies = { "nvim-treesitter/playground" }, ]]
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  init = function() 
          local parser_installed = {
                "javascript",
                "javascript-react",
                "typescript",
                "typescript-react",
                "html",
                "css",
                "elixir",
                "heex",
                "go",
                "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown_inline",
                "markdown",
            }

            require("nvim-treesitter").install(parser_installed)

            -- auto-start highlights & indentation
            vim.api.nvim_create_autocmd("FileType", {
                desc = "User: enable treesitter highlighting",
                pattern = parser_installed,
                callback = function(ctx)
                    -- highlights
                    local ok = pcall(vim.treesitter.start) -- errors for filetypes with no parser
                    -- folds
                    if ok then
                      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    end
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
