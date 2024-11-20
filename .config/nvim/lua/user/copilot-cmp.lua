local M = {
    "zbirenbaum/copilot-cmp",
}

function M.config()
    local status_ok, copilot_cmp = pcall(require, "copilot_cmp")
    if not status_ok then
        return
    end
end

return M
