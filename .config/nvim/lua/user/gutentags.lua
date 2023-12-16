local M = {
    "ludovicchabant/vim-gutentags",
    commit = "aa47c5e29c37c52176c44e61c780032dfacef3dd",
    event = "VeryLazy",
}

vim.g["gutentags_ctags_exclude_wildignore"] = 1
vim.g["gutentags_ctags_exclude"] = {
    "node_modules",
    "_build",
    "build",
    "CMakeFiles",
    ".mypy_cache",
    "venv",
    "*.md",
    "*.tex",
    "*.css",
    "*.html",
    "*.json",
    "*.xml",
    "*.xmls",
    "*.ui",
    "*.lua"
}

vim.g["gutentags_project_root"] = { "Makefile", ".git", "package.json" }
vim.g["gutentags_ctags_tagfile"] = ".tags"
local vim_tags = vim.fn.expand('~/.cache/tags')
vim.g["gutentags_cache_dir"] = vim_tags
vim.g["gutentags_ctags_extra_args"] =  "--fields=+iaS --extra=+q --c++-kinds=+p --c-kinds=+p"

function M.config()
    local status_ok, gutentag = pcall(require, "vim-gutentags")
    if not status_ok then
        return
    end
end

return M
