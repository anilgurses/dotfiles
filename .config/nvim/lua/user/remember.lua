local M = {
  "ethanholz/nvim-lastplace",
  commit = "75a2b78bdbbd20467d499defceb5b20c0967a1ca",
  event = "VeryLazy",
}

function M.config()
  local status_ok, lastplace = pcall(require, "nvim-lastplace")
  if not status_ok then
        return
  end
  lastplace.setup {
    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
    lastplace_open_folds = true,
  }
end

return M
