local actions = require("telescope.actions")
local layout = require("telescope.actions.layout")

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
        -- clear prompt rather than scrolling the preview, clearing the other
        -- movements as well for consistency
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-f>"] = false,
        ["<C-k>"] = false,
        -- close rather than going into normal mode
        ["<esc>"] = actions.close,
        -- remap some keys to make them more intuitive and to account for
        -- the deleted C-u above
        ["<M-n>"] = actions.preview_scrolling_down,
        ["<M-r>"] = actions.preview_scrolling_up,
        ["<M-s>"] = actions.preview_scrolling_left,
        ["<M-t>"] = actions.preview_scrolling_right,
        ["<C-b>"] = actions.results_scrolling_left,
        ["<C-f>"] = actions.results_scrolling_right,
        -- toggle the preview
        ["<M-p>"] = layout.toggle_preview,
      },
    },
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<M-d>"] = actions.delete_buffer + actions.move_to_top,
        },
      },
    },
  },
  extensions = {},
}

-- keymap settings
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Telescope all commands" })
vim.keymap.set("n", "<leader>fC", builtin.command_history, { desc = "Telescope command history" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fF", builtin.git_files, { desc = "Telescope find git files" })
vim.keymap.set("n", "<leader>fgb", builtin.git_branches, { desc = "Telescope git branches" })
vim.keymap.set("n", "<leader>fgB", builtin.git_bcommits, { desc = "Telescope git blame" })
vim.keymap.set("v", "<leader>fgB", builtin.git_bcommits_range, { desc = "Telescope git blame (selected lines)" })
vim.keymap.set("n", "<leader>fgc", builtin.git_commits, { desc = "Telescope git commits" })
vim.keymap.set("n", "<leader>fgs", builtin.git_status, { desc = "Telescope git status" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "Telescope jumplist" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
vim.keymap.set("n", "<leader>fl", builtin.loclist, { desc = "Telescope location list" })
vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Telescope marks" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope recent files" })
vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "Telescope quickfix list" })
vim.keymap.set("n", "<leader>fQ", builtin.quickfixhistory, { desc = "Telescope quickfix history" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Telescope resume" })
vim.keymap.set("n", "<leader>fR", builtin.registers, { desc = "Telescope registers" })
vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Telescope live grep (search)" })
vim.keymap.set("n", "<leader>fS", builtin.search_history, { desc = "Telescope search history" })
vim.keymap.set("n", "<leader>ft", builtin.colorscheme, { desc = "Telescope colorschemes (themes)" })
vim.keymap.set("n", "<leader>fT", builtin.filetypes, { desc = "Telescope filetypes" })
vim.keymap.set("n", "<leader>fv", builtin.vim_options, { desc = "Telescope vim options" })

vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<C-b>", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>*", builtin.grep_string, { desc = "Telescope search string under cursor" })
