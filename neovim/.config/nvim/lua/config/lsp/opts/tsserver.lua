local util = require("lspconfig.util")
local opts = {
  root_dir = function(fname)
    return util.root_pattern('tsconfig.json', 'assets/tsconfig.json', 'jsconfig.json', 'assets/jsconfig.json',
      'assets/package.json', '.git')(fname)
  end
}
return opts
