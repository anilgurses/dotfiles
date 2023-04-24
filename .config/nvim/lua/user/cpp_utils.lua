local M = {
"vim-scripts/DoxygenToolkit.vim",
commit = "afd8663d36d2ec19d26befdb10e89e912d26bbd3",
event = "VeryLazy"
}

function M.config()
    local status_ok, doxygenToolkit = pcall(require, "DoxygenToolkit.vim")
    if not status_ok then
      return
    end

    vim.g['DoxygenToolkit_commentType'] = "C++"
end

return M


