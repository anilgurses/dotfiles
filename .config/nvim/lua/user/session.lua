local M = {
  "rmagatti/auto-session",
  event = "VimEnter",
  dependencies = { "ahmedkhalf/project.nvim" },
}

function M.config()
  require("auto-session").setup {
    log_level = "error",
    auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions",
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_suppress_dirs = { vim.fn.expand "~", "/" },
  }
end

return M
