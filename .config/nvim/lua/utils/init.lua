local M = {}

-- List https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
M.servers = {
    "lua_ls",
    "cssls",
    "html",
    "tsserver",
    "pyright",
    "bashls",
    "jsonls",
    "yamlls",
    "clangd",
    "cmake",
    "dockerls",
    "docker_compose_language_service",
    "opencl_ls",
    "pylsp"
}

return M
