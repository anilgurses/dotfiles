local M = {}

local CONFIG_PATH = vim.fn.expand("~/.config/nvim/build_containers.lua")
local DEFAULT_CMD = "bd"
local LOG_DIR = "/tmp/nvim-build-logs"

local function normalize_path(path)
  local full = vim.fn.fnamemodify(path, ":p")
  return full:gsub("/$", "")
end

local function detect_project_root()
  local ok, project = pcall(require, "project_nvim.project")
  if ok and project.get_project_root then
    local root = project.get_project_root()
    if root and root ~= "" then
      return normalize_path(root)
    end
  end
  return normalize_path(vim.loop.cwd())
end

local function load_config()
  local ok, cfg = pcall(dofile, CONFIG_PATH)
  if not ok then
    vim.notify(
      ("build_container: missing or invalid config at %s"):format(CONFIG_PATH),
      vim.log.levels.WARN
    )
    return nil
  end
  if type(cfg) ~= "table" then
    vim.notify(("build_container: config must return a table: %s"):format(CONFIG_PATH), vim.log.levels.ERROR)
    return nil
  end
  return cfg
end

local function project_key(root)
  local name = vim.fn.fnamemodify(root, ":t")
  return name:gsub("[^%w%-_%.]+", "_")
end

local function ensure_log_dir(root)
  if vim.fn.isdirectory(LOG_DIR) == 0 then
    vim.fn.mkdir(LOG_DIR, "p")
  end
  local dir = ("%s/%s"):format(LOG_DIR, project_key(root))
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  return dir
end

local function clear_project_logs(root)
  local dir = ("%s/%s"):format(LOG_DIR, project_key(root))
  if vim.fn.isdirectory(dir) == 1 then
    vim.fn.delete(dir, "rf")
  end
  vim.fn.mkdir(dir, "p")
end

local function log_path(root, label)
  local stamp = vim.fn.strftime("%Y%m%d-%H%M%S")
  local safe = (label or "container"):gsub("[^%w%-_%.]+", "_")
  local dir = ensure_log_dir(root)
  return ("%s/%s-%s.log"):format(dir, safe, stamp)
end

local function append_log(path, data)
  if not data then
    return
  end
  local lines = {}
  for _, line in ipairs(data) do
    if line ~= "" then
      table.insert(lines, line)
    end
  end
  if #lines == 0 then
    return
  end
  local f = io.open(path, "a")
  if not f then
    return
  end
  f:write(table.concat(lines, "\n") .. "\n")
  f:close()
end

local function setup_term_buf()
  vim.opt_local.bufhidden = "hide"
  vim.bo.buflisted = false
  vim.opt_local.swapfile = false
end

local function create_term_window()
  vim.cmd("botright new")
  vim.cmd("resize 15")
  setup_term_buf()
  return vim.api.nvim_get_current_win()
end

local function open_term_in_window(win, cmd, log_file, on_exit)
  if not win or not vim.api.nvim_win_is_valid(win) then
    win = create_term_window()
  else
    vim.api.nvim_set_current_win(win)
    vim.cmd("enew")
    setup_term_buf()
  end
  vim.fn.termopen(cmd, {
    on_stdout = function(_, data, _)
      append_log(log_file, data)
    end,
    on_stderr = function(_, data, _)
      append_log(log_file, data)
    end,
    on_exit = function(_, code, _)
      if on_exit then
        on_exit(code)
      end
    end,
  })
  vim.cmd("startinsert")
  return win
end

local function build_command_string(cfg, project_cfg, item)
  local cmd = item.command or project_cfg.command or cfg.command or DEFAULT_CMD
  local bd_alias = item.bd_alias or project_cfg.bd_alias or cfg.bd_alias
  if cmd == "bd" and bd_alias and bd_alias ~= "" then
    return bd_alias
  end
  return cmd
end

local function shell_cd(workdir)
  if not workdir or workdir == "" then
    return ""
  end
  return "cd " .. vim.fn.shellescape(workdir)
end

local function container_label(item)
  return item.label or item.name or "container"
end

local function build_exec_parts(cfg, project_cfg, item)
  local engine = item.engine or cfg.default_engine or "docker"
  local name = item.name
  local workdir = item.workdir
  if not name then
    return nil, "build_container: container name is required"
  end

  local parts = { engine, "exec", "-it" }
  local user_flag = item.user or project_cfg.user or cfg.user
  if user_flag and user_flag ~= "" then
    table.insert(parts, "-u")
    table.insert(parts, user_flag)
  end
  table.insert(parts, name)
  local shell = item.shell or project_cfg.shell or cfg.shell or "bash"
  local shell_init = item.shell_init or project_cfg.shell_init or cfg.shell_init or "source ~/.bashrc"
  local build_cmd = build_command_string(cfg, project_cfg, item)
  local cd_cmd = shell_cd(workdir)
  table.insert(parts, shell)
  table.insert(parts, "-lc")
  local segments = {}
  if shell_init and shell_init ~= "" then
    table.insert(segments, shell_init)
  end
  if cd_cmd ~= "" then
    table.insert(segments, cd_cmd)
  end
  table.insert(segments, build_cmd)
  table.insert(parts, table.concat(segments, " && "))

  return parts
end

local function get_project_config()
  local cfg = load_config()
  if not cfg then
    return
  end

  local root = detect_project_root()
  local projects = cfg.projects or {}
  local project_cfg = projects[root]
  if not project_cfg then
    vim.notify(("build_container: no config for project %s"):format(root), vim.log.levels.WARN)
    return
  end

  local containers = project_cfg.containers or {}
  if #containers == 0 then
    vim.notify(("build_container: no containers configured for %s"):format(root), vim.log.levels.WARN)
    return
  end
  return cfg, project_cfg, containers, root
end

local function build_all_containers()
  local cfg, project_cfg, containers, root = get_project_config()
  if not cfg then
    return
  end

  clear_project_logs(root)
  local win = create_term_window()
  local index = 1

  local function run_next(exit_code)
    if exit_code and exit_code ~= 0 then
      vim.notify("build_container: previous build failed, stopping", vim.log.levels.ERROR)
      return
    end

    local item = containers[index]
    if not item then
      return
    end
    index = index + 1

    local parts, err = build_exec_parts(cfg, project_cfg, item)
    if not parts then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end

    local label = container_label(item)
    local log_file = log_path(root, label)
    vim.notify(("build_container: building %s (log: %s)"):format(label, log_file))
    win = open_term_in_window(win, parts, log_file, run_next)
  end

  run_next(0)
end

local function build_in_container()
  local cfg, project_cfg, containers, root = get_project_config()
  if not cfg then
    return
  end

  if project_cfg.run_all or cfg.run_all then
    build_all_containers()
    return
  end

  clear_project_logs(root)
  vim.ui.select(containers, {
    prompt = "Build container",
    format_item = container_label,
  }, function(item)
    if not item then
      return
    end
    local parts, err = build_exec_parts(cfg, project_cfg, item)
    if not parts then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end
    local label = container_label(item)
    local log_file = log_path(root, label)
    vim.notify(("build_container: building %s (log: %s)"):format(label, log_file))
    local win = create_term_window()
    open_term_in_window(win, parts, log_file)
  end)
end

local function list_log_files(root)
  local dir = ensure_log_dir(root)
  local files = vim.fn.glob(dir .. "/*.log", false, true)
  table.sort(files)
  return files
end

local function open_log()
  local _, _, _, root = get_project_config()
  if not root then
    return
  end
  local files = list_log_files(root)
  if #files == 0 then
    vim.notify("build_container: no logs found", vim.log.levels.WARN)
    return
  end
  vim.ui.select(files, {
    prompt = "Build logs",
    format_item = function(path)
      return vim.fn.fnamemodify(path, ":t")
    end,
  }, function(path)
    if not path then
      return
    end
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("BuildInContainer", build_in_container, {})
  vim.api.nvim_create_user_command("BuildAllContainers", build_all_containers, {})
  vim.api.nvim_create_user_command("BuildContainerLogs", open_log, {})
  vim.api.nvim_create_user_command("BuildContainerEditConfig", function()
    vim.cmd("edit " .. CONFIG_PATH)
  end, {})
end

M.setup()

return M
