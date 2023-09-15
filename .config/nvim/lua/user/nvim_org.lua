local M = {
  "nvim-neorg/neorg",
  lazy = false,
  build = ":Neorg sync-parsers",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  cmd = "Neorg",
}

function M.config()
  local status_ok, orgmode = pcall(require, "neorg")
  if not status_ok then
    return
  end

  orgmode.setup {
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      -- ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
      ["core.concealer"] = { config = { icon_preset = "varied" } },
      ["core.dirman"] = { -- Manages Neorg workspaces
        config = {
          workspaces = {
            notes = "~/notes/general",
            phd = "~/notes/phd",
            wiki = "~/notes/wiki",
            personal = "~/notes/personal"
          },
          default_workspace = "notes"
        },
      },
      ["core.keybinds"] = {
        -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
        config = {
          default_keybinds = true,
          -- neorg_leader = "<Leader><Leader>",
        },
      },
    },
  }
end

return M
