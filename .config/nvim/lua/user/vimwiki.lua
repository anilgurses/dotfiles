local M = {
    "vimwiki/vimwiki",
    lazy = false,
    init = function()
        vim.g.vimwiki_list = {
            {
                syntax = "markdown",
                ext = ".md",
                path = "~/notes/wiki/", -- does not work?=!?!?
            },
        }

        vim.g.vimwiki_ext2syntax = {
            [".md"] = "markdown",
            [".markdown"] = "markdown",
            [".mdown"] = "markdown",
        }
        vim.g.vimwiki_markdown_link_ext = 1 -- add markdown file extension when generating links
        vim.g.taskwiki_markdown_syntax = "markdown"
        vim.g.vimwiki_global_ext = 0
    end,
}

function M.config()
    local status_ok, vimwiki = pcall(require, "vimwiki")
    if not status_ok then
        return
    end
end

return M
