local M = {
"folke/todo-comments.nvim",
commit = "74c7d28cb50b0713c881ef69bcb6cdd77d8907d1",
event = "VeryLazy"
}

function M.config()
   local todo_status_ok, todo = pcall(require, "todo-comments")
    if not todo_status_ok then
      return
    end
    todo.setup()
end

return M
