local module = "ibl"
local status_ok, indent_blankline = pcall(require, module)
if not status_ok then
  vim.notify(module .. " is not installed")
  return
end

indent_blankline.setup {
  scope = {
    show_start = false
  }
}
