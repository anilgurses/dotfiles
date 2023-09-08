local M = {
    "nvim-orgmode/orgmode",
    lazy = false,
}

function M.config()
    local status_ok, orgmode = pcall(require, "orgmode")
    if not status_ok then
      return
    end
    orgmode.setup_ts_grammar()

    orgmode.setup({
      org_agenda_files = {'~/org/agenda/*', '~/my-orgs/**/*'},
      org_default_notes_file = '~/org/notes/refile.org',
    })
end

return M


