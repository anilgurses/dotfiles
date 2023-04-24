-- local M = {
--   "folke/tokyonight.nvim",
--   commit = "e52c41314e83232840d6970e6b072f9fba242eb9",
--   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
-- }

local M = {
  "sainnhe/gruvbox-material",
  commit = "3fff63b0d6a425ad1076a260cd4f6da61d1632b1",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

vim.g["gruvbox_material_background"] = "medium"
vim.g["gruvbox_material_better_performance"] = 1
vim.g["gruvbox_material_sign_column_background"] = "grey"

M.name = "gruvbox-material"
function M.config()
  local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
  if not status_ok then
    return
  end
end

return M
