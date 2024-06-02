local M = {
    "github/copilot.vim",
    event = "VeryLazy",
}

function M.config()
    local status_ok, cpilot = pcall(require, "copilot.vim")
    if not status_ok then
        return
    end

end

return M
