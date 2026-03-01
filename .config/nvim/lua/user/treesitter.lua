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
  "vlog",
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
  lazy = false,
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
  local ts = require("nvim-treesitter")
  ts.setup()

  local available = {}
  for _, lang in ipairs(ts.get_available()) do
    available[lang] = true
  end

  local installed = {}
  for _, lang in ipairs(ts.get_installed()) do
    installed[lang] = true
  end

  local missing = {}
  for _, lang in ipairs(parsers) do
    if available[lang] and not installed[lang] then
      table.insert(missing, lang)
    end
  end

  if #missing > 0 then
    ts.install(missing, { summary = true })
  end

  local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      if highlight_disabled[ft] then
        return
      end

      if not pcall(vim.treesitter.start, args.buf) then
        return
      end

      if not indent_disabled[ft] then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M
