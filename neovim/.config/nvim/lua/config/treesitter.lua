local M = {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/playground" },
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
}

function M.config()
  require("nvim-treesitter.configs").setup {
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers) or a list of languages
    auto_install = true,
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
    autopairs = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    highlight = {
      enable = true, -- false will disable to whole extension
      disable = { "yaml" }, -- list of languages that will be disabled
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = { "yaml" } },
    playground = {
      enable = true,
    }
  }
end

return M
