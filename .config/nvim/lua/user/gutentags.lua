local M = {
"ludovicchabant/vim-gutentags",
commit = "1337b1891b9d98d6f4881982f27aa22b02c80084",
event = "VeryLazy"
}

vim.g["gutentags_ctags_exclude_wildignore"] = 1
vim.g["gutentags_ctags_exclude"] = " [ \
  'node_modules', '_build', 'build', 'CMakeFiles', '.mypy_cache', 'venv', \
  '*.md', '*.tex', '*.css', '*.html', '*.json', '*.xml', '*.xmls', '*.ui']"

function M.config()
    local status_ok, gutentag = pcall(require, "vim-gutentags")
    if not status_ok then
      return
    end
end

return M


