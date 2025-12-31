local M = {
    "folke/todo-comments.nvim",
    commit = "4a6737a8d70fe1ac55c64dfa47fcb189ca431872",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
}

function M.config()
    local todo_status_ok, todo = pcall(require, "todo-comments")
    if not todo_status_ok then
        return
    end
    todo.setup()
end

return M
