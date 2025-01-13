local M = {}

-- List https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- :help lspconfig-all
M.servers = {
    "lua_ls",
    "html",
    "pyright",
    "ruff",
    "bashls",
    "jsonls",
    "yamlls",
    "clangd",
    "cmake",
    "dockerls",
    "docker_compose_language_service",
    "opencl_ls",
}

return M
