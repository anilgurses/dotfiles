local M = {
    "github/copilot.vim",
    event = "VeryLazy",
}

function M.config()
    local status_ok, cpilot = pcall(require, "copilot.vim")
    if not status_ok then
        return
    end

    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
end

return M
