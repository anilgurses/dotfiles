local M = {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "latex" },
}

function M.config()
    local latex_ok, latx = pcall(require, "vimtex")
    if not latex_ok then
        return
    end
    latx.setup()
    vim.g.vimtex_view_general_viewer = "okular"
    vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
    vim.g.vimtex_compiler_method = "latexrun"

    vim.g.vimtex_quickfix_ignore_filters = {
        "Command terminated with space",
        "LaTeX Font Warning: Font shape",
        "Package caption Warning: The option",
        [[Underfull \\hbox (badness [0-9]*) in]],
        "Package enumitem Warning: Negative labelwidth",
        [[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in]],
        [[Package caption Warning: Unused \\captionsetup]],
        "Package typearea Warning: Bad type area settings!",
        [[Package fancyhdr Warning: \\headheight is too small]],
        [[Underfull \\hbox (badness [0-9]*) in paragraph at lines]],
        "Package hyperref Warning: Token not allowed in a PDF string",
        [[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in paragraph at lines]],
    }

    vim.g.vimtex_fold_enabled = 1
    vim.g.vimtex_fold_manual = 1
end

return M
