local M = {
    "lervag/vimtex",
    commit = "877de3ba5de5f766e5bfa1c3fb0d2ecfcd18f868",
    lazy = false,
}

function M.config()
    local latex_ok, latx = pcall(require, "vimtex")
    if not latex_ok then
        return
    end
    latx.setup()
    vim.g["vimtex_view_general_viewer"] = "okular"
    vim.g["vimtex_view_general_options"] = "--unique file:@pdf\\#src:@line@tex"
    vim.g["vimtex_compiler_method"] = "latexrun"
end

return M
