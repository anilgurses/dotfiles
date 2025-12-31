local M = {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
}

function M.config()
    require("leetcode").setup {}
end

return M
