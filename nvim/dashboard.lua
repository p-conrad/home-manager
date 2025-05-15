require("dashboard").setup {
    theme = "hyper",
    config = {
        week_header = { enable = true, },
        packages = { enable = false, },
        shortcut = {
            {
                icon = " ",
                icon_hl = "@variable",
                desc = "Files",
                group = "Label",
                action = "Telescope find_files",
                key = "f",
            },
            {
                desc = " Apps",
                group = "DiagnosticHint",
                action = "Telescope app",
                key = "a",
            },
            {
                desc = " dotfiles",
                group = "Number",
                action = "Telescope dotfiles",
                key = "d",
            },
        },
    },
}
