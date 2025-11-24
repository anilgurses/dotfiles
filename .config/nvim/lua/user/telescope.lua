local M = {
    "nvim-telescope/telescope.nvim",
    commit = "40c31fdde93bcd85aeb3447bb3e2a3208395a868",
    event = "Bufenter",
    cmd = { "Telescope" },
    dependencies = {
        {
            "ahmedkhalf/project.nvim",
            commit = "8c6bad7d22eef1b71144b401c9f74ed01526a4fb",
        },
        {
            "nvim-telescope/telescope-bibtex.nvim",
            commit = "e4dcf64d351db23b14be3563190cf68d5cd49e90",
        },
    },
}

local actions = require "telescope.actions"

function M.config()
    require("telescope").setup {
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            path_display = { "smart" },
            file_ignore_patterns = { ".git/", "node_modules" },
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
                "-g",
                "!.git/",
            },
            mappings = {
                i = {
                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                },
            },
        },
        extensions = {
            bibtex = {
                context = true,
            },
            notify = {
                position = "top",
                timeout = 2,
            },
        },
    }
end

return M