local status_ok, doxygenToolkit = pcall(require, "DoxygenToolkit.vim")
if not status_ok then
  return
end

vim.g['DoxygenToolkit_commentType'] = "C++"
