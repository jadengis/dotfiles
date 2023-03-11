local module = "auto-session"
local status_ok, auto_session = pcall(require, module)
if not status_ok then
  vim.notify("module named " .. module .. " not found")
  return
end

auto_session.setup {}
