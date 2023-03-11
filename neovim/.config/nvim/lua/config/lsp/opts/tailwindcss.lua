local util = require "lspconfig.util"
local opts = {
  init_options = {
    userLanguages = {
      elixir = "html",
      heex = "html"
    }
  },
  root_dir = function (fname)
    return util.root_pattern('tailwind.config.js', 'assets/tailwind.config.js', 'tailwind.config.ts')(fname)
  end
}
return opts
