local M = {
  "kevinhwang91/nvim-ufo",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "kevinhwang91/promise-async",
  },
}

function M.config()
  vim.o.foldcolumn = "1"
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  local ufo = require("ufo")

  vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
  vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
  vim.keymap.set("n", "zp", ufo.peekFoldedLinesUnderCursor, { desc = "Preview folded lines" })

  ufo.setup({
    provider_selector = function(_, filetype, buftype)
      if buftype ~= "" then
        return ""
      end

      if filetype == "tex" or filetype == "plaintex" or filetype == "latex" then
        return ""
      end

      if filetype == "markdown" then
        return { "treesitter", "indent" }
      end

      return { "lsp", "treesitter" }
    end,
  })
end

return M
