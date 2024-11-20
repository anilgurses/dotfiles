local M = {
    "kkoomen/vim-doge",
    lazy=false
}

function M.config()
    local status_ok, doge = pcall(require, "doge")
    if not status_ok then
        return
    end
    
    vim.g["doge_mapping"] = "<leader>d"


end

return M
