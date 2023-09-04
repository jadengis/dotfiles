local opts = {
  filetypes = { "html", "elixir", "heex" },
  init_options = {
    provideFormatter = false
  },
  settings = {
    html = {
      format = {
        enable = false
      },
      hover = {
        documentation = true,
        references = true,
      }
    },
  },
  breadcrumbs = {
    filetypes = { "html", "heex" },
  }
}
return opts
