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
        icon = "󱃔 ",
        icon_hl = "@variable",
        desc = "Agenda",
        group = "Label",
        action = "Org agenda",
        key = "a",
      },
    },
  },
}
