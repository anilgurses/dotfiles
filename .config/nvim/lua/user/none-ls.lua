local M = {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
            lazy = true,
        },
    },
}

function M.config()
    local null_ls = require "null-ls"

    -- Formatting is handled by conform.nvim (see lua/user/conform.lua).
    null_ls.setup {
        sources = {
            null_ls.builtins.completion.spell,
            null_ls.builtins.code_actions.gitsigns,
        },
    }
end

return M
