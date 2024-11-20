local M = {
    "rcarriga/nvim-notify",
    commit = "fbef5d32be8466dd76544a257d3f3dce20082a07",
}

function M.config()
    local status_ok, notify = pcall(require, "notify")
    vim.notify = require "notify"
    if not status_ok then
        return
    end
end

return M
