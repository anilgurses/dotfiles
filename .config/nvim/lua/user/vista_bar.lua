local M = {
"liuchengxu/vista.vim",
commit = "cbe87c86505d80fe5ad7fd508f2d92185f2e2aa1",
event = "VeryLazy"
}
vim.g["vista_default_executive"] = 'ctags'
function M.config()
    local status_ok, vist = pcall(require, "vist.vim")
    if not status_ok then
      return
    end
end

return M


