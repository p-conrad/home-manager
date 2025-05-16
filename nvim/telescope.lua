require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
      }
    }
  },
  pickers = {},
  extensions = {},
}

-- keymap settings
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fc", builtin.colorscheme, { desc = "Telescope colorschemes" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope recent files" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Telescope recent commands" })
vim.keymap.set("n", "<leader>fR", builtin.registers, { desc = "Telescope registers" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Telescope resume" })

vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<C-b>", builtin.buffers, { desc = "Telescope buffers" })
