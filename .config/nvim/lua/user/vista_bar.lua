local M = {
"liuchengxu/vista.vim",
commit = "c07585b588071adc8e9670becadb89307153e4d1",
event = "VeryLazy"
}
vim.g["vista_default_executive"] = 'ctags'
function M.config()
    local status_ok, vista = pcall(require, "vista.vim")
    if not status_ok then
      return
    end
end

return M


