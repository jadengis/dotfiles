local colorscheme = "darkplus"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end

-- Copilot hightlight
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
