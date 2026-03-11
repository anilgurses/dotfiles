local parsers = {
  "lua",
  "markdown",
  "markdown_inline",
  "bash",
  "python",
  "cpp",
  "c",
  "cmake",
  "dockerfile",
  "devicetree",
  "go",
  "html",
  "matlab",
  "verilog",
  "proto",
  "yaml",
}

local highlight_disabled = {
  css = true,
}

local indent_disabled = {
  css = true,
  python = true,
}

local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
    },
    {
      "nvim-tree/nvim-web-devicons",
      event = "VeryLazy",
    },
  },
}

function M.init()
  vim.g.skip_ts_context_commentstring_module = true
end

function M.config()
  local ok, configs = pcall(require, "nvim-treesitter.configs")
  local mod = ok and configs or require("nvim-treesitter")
  mod.setup({
    ensure_installed = parsers,
    auto_install = true,
    highlight = {
      enable = true,
      disable = vim.tbl_keys(highlight_disabled),
    },
    indent = {
      enable = true,
      disable = vim.tbl_keys(indent_disabled),
    },
  })
end

return M
