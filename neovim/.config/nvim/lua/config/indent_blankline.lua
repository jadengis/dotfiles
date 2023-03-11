local module = "indent_blankline"
local status_ok, indent_blankline = pcall(require, module)
if not status_ok then
  vim.notify(module .. " is not installed")
  return
end

indent_blankline.setup {
  show_current_context = true,
  show_current_context_start = false,
}
