local M = {
    "wakatime/vim-wakatime",
    lazy = false,
}

function M.config()
    local waka_status_ok, wakatime = pcall(require, "vim-wakatime")
    if not waka_status_ok then
        return
    end
end

return M
