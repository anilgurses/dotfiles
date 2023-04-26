-- local M = {
--   "folke/tokyonight.nvim",
--   commit = "e52c41314e83232840d6970e6b072f9fba242eb9",
--   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
-- }

local M = {
  "ellisonleao/gruvbox.nvim",
  commit = "df149bccb19a02c5c2b9fa6ec0716f0c0487feb0",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

-- vim.g["gruvbox_material_background"] = "medium"
-- vim.g["gruvbox_material_better_performance"] = 1
-- vim.g["gruvbox_material_sign_column_background"] = "grey"

M.name = "gruvbox"
function M.config()
  local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
  if not status_ok then
    return
  end
end

return M
