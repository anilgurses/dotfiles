local M = {
  "nvim-neorg/neorg",
  lazy = false,
  build = ":Neorg sync-parsers",
  dependencies = { "nvim-lua/plenary.nvim" },
}

function M.config()
  local status_ok, orgmode = pcall(require, "neorg")
  if not status_ok then
    return
  end

  orgmode.setup {
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
      ["core.dirman"] = { -- Manages Neorg workspaces
        config = {
          workspaces = {
            notes = "~/notes/general",
            phd = "~/notes/phd",
            wiki = "~/notes/wiki",
          },
        },
      },
    },
  }
end

return M
