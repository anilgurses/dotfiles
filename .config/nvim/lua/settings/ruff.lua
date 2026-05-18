-- Ruff acts as the Python linter + code-action provider.
-- Formatting and import-organizing are handled by conform.nvim (also via ruff),
-- so pyright/ruff stay out of the formatting path.
return {
    init_options = {
        settings = {
            organizeImports = true,
            fixAll = true,
            lint = {
                enable = true,
            },
        },
    },
}
