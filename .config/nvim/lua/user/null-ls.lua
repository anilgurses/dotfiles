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
            formatting.black,
            formatting.autoflake,
            formatting.autopep8,
            formatting.prettier.with {
                extra_filetypes = { "toml", "cpp" },
                -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
            },
            -- null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.completion.spell,
        },
    }
end

return M
