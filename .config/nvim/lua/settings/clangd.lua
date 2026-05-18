local util = require "lspconfig.util"
local uv = vim.uv or vim.loop

local function find_compile_commands_dir(root_dir)
  local candidates = {
    root_dir,
    root_dir .. "/build",
    root_dir .. "/host/build",
    root_dir .. "/cmake-build-debug",
    root_dir .. "/cmake-build-release",
    root_dir .. "/build/debug",
    root_dir .. "/build/release",
  }

  for _, dir in ipairs(candidates) do
    if uv.fs_stat(dir .. "/compile_commands.json") then
      return dir
    end
  end

  return nil
end

local base_cmd = {
  "clangd",
  "--background-index",
  "--clang-tidy",
  "--completion-style=detailed",
  "--header-insertion=iwyu",
  "--all-scopes-completion",
  "--function-arg-placeholders",
  "--pch-storage=memory",
  "-j=4",
}

local find_root = util.root_pattern(
  "compile_commands.json",
  "compile_flags.txt",
  ".clangd",
  "CMakeLists.txt",
  ".git"
)

local function make_cmd(root_dir)
  local cmd = vim.deepcopy(base_cmd)
  local cc_dir = root_dir and find_compile_commands_dir(root_dir)
  if cc_dir then
    table.insert(cmd, "--compile-commands-dir=" .. cc_dir)
  end
  return cmd
end

return {
  cmd = function(dispatchers, config)
    local root = (config and config.root_dir) or find_root(uv.cwd())
    return vim.lsp.rpc.start(make_cmd(root), dispatchers)
  end,
  init_options = {
    clangdFileStatus = true,
  },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(find_root(fname) or (fname ~= "" and vim.fs.dirname(fname)) or uv.cwd())
  end,
  single_file_support = true,
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
}
