local M = {}

-- List https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- :help lspconfig-all
M.servers = {
    "lua_ls",
    "html",
    "pyright",
    "bashls",
    "jsonls",
    "yamlls",
    "clangd",
    "cmake",
    "dockerls",
    "docker_compose_language_service",
    "opencl_ls",
}

function M.close_terminal_buffers()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
    end
end

return M
