local M = {
    "nvimtools/none-ls.nvim",
    lazy = false,
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
            lazy = true,
        },
    },
}

function M.config()
    local null_ls = require "null-ls"

    local formatting = null_ls.builtins.formatting

    null_ls.setup {
        sources = {
            formatting.stylua,
            formatting.prettier,
            formatting.prettier.with {
                extra_filetypes = { "toml", "cpp" },
                -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
            },
            -- null_ls.builtins.diagnostics.eslint,
            formatting.black,
            null_ls.builtins.completion.spell,
            null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.diagnostics.flake8,
        },
    }
end

return M
