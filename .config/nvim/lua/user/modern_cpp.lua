local M = {
"bfrg/vim-cpp-modern",
commit = "0f0529bf2a336a4e824a26b733220548d32697a6",
event = "VeryLazy"
}

function M.config()
    local status_ok, cppmodern = pcall(require, "vim-cpp-modern")
    if not status_ok then
      return
    end
end

return M


