return {
    settings = {
        ruff = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
            ignoreStandardLibrary = true,
            organizeImports = true,
            fixAll = true,
            lint = {
                enable = true,
                run = "onType",
            },
        },
    },
}
