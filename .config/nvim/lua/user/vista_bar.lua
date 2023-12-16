local M = {
"liuchengxu/vista.vim",
commit = "290b815cd5a5ff1fb65a48936633d93e2bf14dbd",
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


