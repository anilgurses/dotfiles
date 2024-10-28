local M = {}

-- List https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
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
    "opencl_ls"
}

return M
