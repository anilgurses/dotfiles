local M = {
  "ahmedkhalf/project.nvim",
  event = "VimEnter",
}

function M.config()
  local project = require "project_nvim"
  project.setup {

    -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
    detection_methods = { "pattern" },

    -- patterns used to detect root dir, when **"pattern"** is in detection_methods
    patterns = { ".git", "Makefile", "package.json" },
  }

  local telescope_ok, telescope = pcall(require, "telescope")
  if telescope_ok then
    telescope.load_extension "projects"
  end
end

return M
