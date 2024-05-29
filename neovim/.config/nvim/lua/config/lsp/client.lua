local M = {}

M.setup = function(config)
	local N = {}

	local function lsp_highlight_document(client)
		-- Set autocommands conditional on server_capabilities
		local status_ok, illuminate = pcall(require, "illuminate")
		if not status_ok then
			return
		end
		illuminate.on_attach(client)
	end

	local function lsp_keymaps(bufnr)
		local opts = { noremap = true, silent = true }
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<S-k>", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<S-j>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>.", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"[d",
			'<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"]d",
			'<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>',
			opts
		)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
		vim.cmd(
			[[ command! Format execute 'lua vim.lsp.buf.format({ async = true, filter = function(client) return client.name ~= "tsserver" end })' ]]
		)
	end

	local function lsp_breadcrumbs(client, bufnr)
		local status_ok, navic = pcall(require, "nvim-navic")
		if not status_ok then
			vim.notify("Failed to load nvim-navic")
			return
		end

    -- Enable the breadcrumbs for this buffer by default unless it is explicitly
    -- not to be included.
		local filetype = vim.bo[bufnr].filetype
		local enabled = config.breadcrumbs == nil
			or config.breadcrumbs.filetypes == nil
			or vim.tbl_contains(config.breadcrumbs.filetypes, filetype)

		if client.server_capabilities.documentSymbolProvider and enabled then
			navic.attach(client, bufnr)
		end
	end

	N.on_attach = function(client, bufnr)
		lsp_keymaps(bufnr)
		lsp_highlight_document(client)
		lsp_breadcrumbs(client, bufnr)

		-- Ignore semantic tokens for now due to bad highlights in the current colorscheme.
		--[[ client.server_capabilities.semanticTokensProvider = nil ]]
	end

	local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if not cmp_nvim_lsp_ok then
		return
	end

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	N.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

	return N
end

return M
