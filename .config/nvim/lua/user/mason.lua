local M = {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = "BufReadPre",
    dependencies = {
        {
            "williamboman/mason-lspconfig.nvim",
            lazy = true,
        },
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            lazy = true,
        },
    },
}

local settings = {
    ui = {
        border = "none",
        icons = {
            package_installed = "◍",
            package_pending = "◍",
            package_uninstalled = "◍",
        },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
}

function M.config()
    require("mason").setup(settings)
    require("mason-lspconfig").setup {
        ensure_installed = require("utils").servers,
        automatic_installation = true,
    }
    -- Formatters/linters used by conform.nvim (not LSP servers).
    require("mason-tool-installer").setup {
        ensure_installed = {
            "stylua",
            "prettier",
            "clang-format",
            "ruff",
        },
        run_on_start = true,
    }
end

return M
