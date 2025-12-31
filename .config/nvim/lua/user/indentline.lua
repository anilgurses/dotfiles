local M = {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        enabled = true,
        exclude = {
            filetypes = {
                "help",
                "startify",
                "dashboard",
                "lazy",
                "neogitstatus",
                "NvimTree",
                "Trouble",
                "text",
            },
            buftypes = {
                "terminal",
                "nofile"
            }
        },
        indent = {
            char = { "│" },
        },
        show_trailing_blankline_indent = true,
        show_first_indent_level = true,
        use_treesitter = true,
    }
}


function M.config()
    require("ibl").setup()
end

return M
