local opts = {}
local install_path = vim.fn.stdpath("data") .. "/elixir-ls/language_server.sh"

if vim.fn.empty(vim.fn.glob(install_path)) == 0 then
	opts = {
		cmd = { install_path },
		breadcrumbs = {
			filetypes = { "elixir" },
		},
	}
end
return opts
