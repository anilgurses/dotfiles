local M = {
  "ludovicchabant/vim-gutentags",
  event = { "BufReadPre", "BufNewFile" },
}

function M.init()
  vim.g.gutentags_ctags_exclude_wildignore = 1
  vim.g.gutentags_ctags_exclude = {
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
    "*.xml",
    "*.xmls",
    "*.ui",
    "*.lua",
  }

  vim.g.gutentags_project_root = {
    "compile_commands.json",
    "compile_flags.txt",
    "CMakeLists.txt",
    "Makefile",
    ".git",
  }
  vim.g.gutentags_ctags_tagfile = ".tags"
  vim.g.gutentags_cache_dir = vim.fn.expand "~/.cache/tags"
  vim.fn.mkdir(vim.g.gutentags_cache_dir, "p")

  vim.g.gutentags_generate_on_new = true
  vim.g.gutentags_generate_on_missing = true
  vim.g.gutentags_generate_on_write = true
  vim.g.gutentags_generate_on_empty_buffer = true
  vim.g.gutentags_modules = { "ctags" }
  vim.g.gutentags_ctags_extra_args = {
    "--fields=+iaS",
    "--extras=+q",
    "--c++-kinds=+p",
    "--c-kinds=+p",
  }
end

return M
