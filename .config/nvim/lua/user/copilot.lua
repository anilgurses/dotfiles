local M = {
"github/copilot.vim",
commit = "998cf5ab1b85e844c7e8edb864a997e590df7182",
event = "VeryLazy"
}

function M.config()
    local status_ok, copilot = pcall(require, "Copilot")
    if not status_ok then
      return
    end
end

return M


