local M = {
  "lukas-reineke/indent-blankline.nvim",
  commit = "d4c718467d35bc93714425a7102d82e7e5065280",
  main="ibl"
}


function M.config()
  require("indent_blankline").setup {
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = {
      "help",
      "startify",
      "dashboard",
      "lazy",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "text",
    },
    char = "▏",
    context_char = "▏",
    show_trailing_blankline_indent = false,
    show_first_indent_level = true,
    use_treesitter = true,
    show_current_context = true,
  }

end

return M
