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

  local function handleFallbackException(bufnr, err, providerName)
    if type(err) == "string" and err:match("UfoFallbackException") then
      return require("ufo").getFolds(bufnr, providerName)
    else
      return require("promise").reject(err)
    end
  end

  ufo.setup({
    provider_selector = function(bufnr, filetype, buftype)
      if buftype ~= "" then
        return ""
      end

      if filetype == "tex" or filetype == "plaintex" or filetype == "latex" then
        return ""
      end

      if filetype == "markdown" then
        return { "treesitter", "indent" }
      end

      return function()
        return require("ufo")
          .getFolds(bufnr, "lsp")
          :catch(function(err)
            return handleFallbackException(bufnr, err, "treesitter")
          end)
          :catch(function(err)
            return handleFallbackException(bufnr, err, "indent")
          end)
      end
    end,
  })
end

return M
