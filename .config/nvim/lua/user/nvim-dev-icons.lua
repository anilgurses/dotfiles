local M = {
  "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  commit = "a1425903ab52a0a0460622519e827f224e5b4fee"
}

function M.config()
  require("nvim-web-devicons").setup {
    override = {
      zsh = {
        icon = "",
        color = "#428850",
        cterm_color = "65",
        name = "Zsh",
      },
    },
    color_icons = true,
    default = true,
  }
end

return M
