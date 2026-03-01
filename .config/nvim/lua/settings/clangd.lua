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

return {
  cmd = {
    "clangd",
    "--background-index",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
  },
  init_options = {
    clangdFileStatus = true,
  },
  root_dir = util.root_pattern(
    "compile_commands.json",
    "compile_flags.txt",
    ".clangd",
    "CMakeLists.txt",
    ".git"
  ),
  on_new_config = function(new_config, root_dir)
    local cc_dir = find_compile_commands_dir(root_dir)
    if not cc_dir then
      return
    end

    local arg = "--compile-commands-dir=" .. cc_dir
    for _, existing in ipairs(new_config.cmd) do
      if existing:find("^%-%-compile%-commands%-dir=") then
        return
      end
    end

    table.insert(new_config.cmd, arg)
  end,
  single_file_support = true,
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
}
