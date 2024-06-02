local M = {
    "stevearc/aerial.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
}

function M.config()
    local status_ok, aerial = pcall(require, "aerial")
    if not status_ok then
        return
    end
end

return M
