local M = {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            event = "VeryLazy",
        },
        {
            "nvim-tree/nvim-web-devicons",
            event = "VeryLazy",
        },
    },
}
function M.config()
    local ts = require "nvim-treesitter"
    local ensure_installed = {
        "lua",
        "markdown",
        "markdown_inline",
        "bash",
        "python",
        "cpp",
        "c",
        "cmake",
        "dockerfile",
        "devicetree",
        "go",
        "html",
        "matlab",
        "verilog",
        "proto",
        "yaml",
    }

    ts.setup {
        install_dir = vim.fn.stdpath "data" .. "/site",
    }
    ts.install(ensure_installed)

    local highlight_disable = { css = true }
    local indent_disable = { python = true, css = true }

    vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
            local ft = vim.bo[args.buf].filetype
            if not highlight_disable[ft] then
                pcall(vim.treesitter.start, args.buf)
            end
            if not indent_disable[ft] then
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    })
end

return M
