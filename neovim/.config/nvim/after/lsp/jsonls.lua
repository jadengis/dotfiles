-- Schemas come from SchemaStore.nvim: https://www.schemastore.org/json/
return {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
