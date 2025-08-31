local util = require("lspconfig.util")
local opts = {
  root_dir = function(fname)
    return util.root_pattern('tsconfig.json', 'assets/tsconfig.json', 'jsconfig.json', 'assets/jsconfig.json',
      "package.json", "assets/package.json")(fname)
  end,
  single_file_support = false
}
return opts
