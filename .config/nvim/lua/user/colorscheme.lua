local M = {
    "ellisonleao/gruvbox.nvim",
    lazy = false,  -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
}

-- local M = {
--     "rebelot/kanagawa.nvim",
--     lazy = false,  -- make sure we load this during startup if it is your main colorscheme
--     priority = 1000, -- make sure to load this before all the other start plugins
-- }

-- local M = {
--   "sainnhe/gruvbox-material",
--   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
-- }


vim.g["gruvbox_contrast_dark"] = "medium"
-- vim.g["gruvbox_material_background"] = "medium"
-- vim.g["gruvbox_material_better_performance"] = 1
-- vim.g["gruvbox_material_sign_column_background"] = "grey"
-- vim.g["gruvbox_material_foreground"] = "mix"
--
-- M.name = "gruvbox-material"
-- M.name = "kanagawa-wave"
M.name = "gruvbox"
-- M.name = "kanagawa"

function M.config()
    -- vim.o.background = "dark"
    local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
    if not status_ok then
        return
    end
end

return M
