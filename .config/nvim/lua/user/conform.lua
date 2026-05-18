local M = {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
}

M.opts = {
    formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
    },
    -- Fall back to LSP formatting for filetypes with no formatter above.
    default_format_opts = {
        lsp_format = "fallback",
    },
}

function M.config()
    require("conform").setup(M.opts)

    vim.keymap.set({ "n", "v" }, "<leader>lf", function()
        require("conform").format { async = true, lsp_format = "fallback" }
    end, { noremap = true, silent = true, desc = "Format buffer/selection" })
end

return M
