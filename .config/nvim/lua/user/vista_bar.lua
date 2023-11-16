local M = {
"liuchengxu/vista.vim",
commit = "58dabc027909330970ac549e52bf799a723878c5",
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


