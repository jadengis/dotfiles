local module = "trouble"
local ok, trouble = pcall(require, module)
if not ok then
  vim.notify(module .. " could not be found")
  return
end

trouble.setup {}
