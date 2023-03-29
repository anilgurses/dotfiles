local colorscheme = "gruvbox"
vim.g['cpp_member_highlight'] = "1"
vim.g['cpp_simple_highlight'] = "1"

local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
if not status_ok then
  return
end
