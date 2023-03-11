local module = "impatient"
local status_ok, impatient = pcall(require, module)
if not status_ok then
  vim.notify(module .. " is not installed")
  return
end

impatient.enable_profile()
