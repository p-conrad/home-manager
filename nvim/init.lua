-- generally useful settings
vim.opt.autochdir = true
--vim.api.nvim_create_autocmd( { "BufEnter" }, { command = "silent! lcd %:p:h" } )
vim.opt.cursorline = true
vim.opt.scrolloff = 2
vim.opt.showmode = true
vim.opt.undofile = true;
vim.opt.wildignore:append(
    { "*.o", "*.so", "*.a", "*.swp", "*.zip", "*.gz", "*.xz", "*/node_modules/*",
    "*/.cache/*", "*/__pycache__/*", "*.pyc", "*.pyo", "*.class", "*/.git/*" })
vim.opt.wildmode = { "longest:list", "full" }


-- appearance and statusline (TODO)
local colorscheme = "catppuccin-macchiato"
local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not ok then
    vim.notify("Colorscheme " .. colorscheme .. " not found!")
end
vim.opt.background = "light"
--vim.opt.guifont = "Cascadia Code,Fira Code,Hack,DejaVu Sans Mono,Inconsolata,Menlo:h11"
vim.opt.guifont = "Cascadia Code:h11"
vim.opt.linespace = 2

-- hybrid line numbering with automatic toggling
-- from: https://jeffkreeftmeijer.com/vim-number/
vim.opt.number = true
vim.opt.relativenumber = true;
local num_toggle = vim.api.nvim_create_augroup("numbertoggle", { clear = true });
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
    pattern = "*",
    group = num_toggle,
    command = "set relativenumber",
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
    pattern = "*",
    group = num_toggle,
    command = "set norelativenumber"
})

-- configuration specific to Neovide
if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0
    -- use a shorter trail if we enable cursor animation
    vim.g.neovide_cursor_trail_size = 0.2
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_scroll_animation_length = 0.1
end


-- leader settings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- text formatting and indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.colorcolumn = "80"
vim.opt.textwidth = 100
vim.opt.formatoptions = "qnr1mMjtco/"
-- [[
-- q: allow formatting comments with gq
-- n: recognize numbered lists when formatting
-- r: add comment leader after hitting enter in insert mode
-- 1: don't break afer one-letter word
-- m: break multi-byte characters,
-- M: no space before or after multi-byte char when joining lines
-- j: remove comment leader when joining lines
-- tc: auto-wrap text and comments
-- o/: insert comment leader when hitting o/O, if at the start of the line
-- -> :help fo-table
-- ]]
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = { shift = -1 }
vim.opt.showbreak = "↪"
vim.opt.listchars = { tab = "» ", eol = "¬", nbsp = "•" , trail= "◆" }


-- searching
vim.opt.gdefault = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.keymap.set({"n", "v"}, "/", "/\\v")
vim.keymap.set("n", "<leader>h", ":noh<cr>")
-- search for highlighted or copied text
vim.keymap.set("v", "//", "y/\\V<C-R>\"<cr>")
vim.keymap.set("n", "//", "/<C-R>0<cr>")


-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- open a new split and focus it
vim.keymap.set("n", "<leader>w", "<C-w>v<C-w>l")

-- rotating splits
vim.keymap.set("n", "<M-r>", "<C-w>r")

-- moving splits
vim.keymap.set("n", "<C-w>S", "<C-w>H")
vim.keymap.set("n", "<C-w>N", "<C-w>J")
vim.keymap.set("n", "<C-w>R", "<C-w>K")
vim.keymap.set("n", "<C-w>T", "<C-w>L")

-- navigating splits
vim.keymap.set("n", "<C-s>", "<C-w>h")
vim.keymap.set("n", "<C-n>", "<C-w>j")
vim.keymap.set("n", "<C-r>", "<C-w>k")
vim.keymap.set("n", "<C-t>", "<C-w>l")

-- remap 'redo' since we are using <C-r> for navigation
vim.keymap.set("n", "<C-j>", "<C-r>")

-- resizing splits
function v_resize(size)
    -- vertically resize the current split, returning the cursor to its window
    local win_nr = vim.fn.winnr()
    vim.cmd("1wincmd w")
    if type(size) == "number" then
        size = math.floor(vim.opt.columns:get() * size)
    end
    vim.cmd("vertical resize " .. size)
    vim.cmd(win_nr .. "wincmd w")
end

vim.keymap.set("n", "<C-x>1", "<C-w>o")
vim.keymap.set("n", "<leader>_", "<C-w>_")
vim.keymap.set("n", "<leader>|", "<C-w>|")
vim.keymap.set("n", "<leader>=", "<C-w>=")
vim.keymap.set("n", "<M-Up>", ":resize -5<cr>", { silent = true })
vim.keymap.set("n", "<M-Down>", ":resize +5<cr>", { silent = true })
vim.keymap.set("n", "<M-Left>", function() v_resize("-5") end, { silent = true })
vim.keymap.set("n", "<M-Right>", function() v_resize("+5") end, { silent = true })
vim.keymap.set("n", "<leader>1", function() v_resize(8/16) end, { silent = true })
vim.keymap.set("n", "<leader>2", function() v_resize(9/16) end, { silent = true })
vim.keymap.set("n", "<leader>3", function() v_resize(10/16) end, { silent = true })
vim.keymap.set("n", "<leader>4", function() v_resize(11/16) end, { silent = true })
vim.keymap.set("n", "<leader>5", function() v_resize(12/16) end, { silent = true })


-- shifting lines or regions up/down
function line_shift(delta)
    -- This helper functions calls :move to shift a line into a given direction,
    -- restoring the cursor position after the movement,
    -- while also taking potential reindentation into account
    local orig_pos = vim.fn.getpos(".")
    vim.cmd("normal! ^")
    local orig_indent = vim.fn.getpos(".")[3]

    local move_arg
    if delta < 0 then
        move_arg = tostring(delta - 1)
    else
        move_arg = "+" .. delta
    end
    vim.cmd("move ." .. move_arg)
    vim.cmd("normal! ==")

    vim.cmd("normal! ^")
    local indent_diff = vim.fn.getpos(".")[3] - orig_indent

    vim.fn.setpos(".", { orig_pos[1], orig_pos[2] + delta, orig_pos[3] + indent_diff, orig_pos[4] })
end
vim.keymap.set("n", "<S-Down>", function() line_shift(1) end, { silent = true })
vim.keymap.set("n", "<S-Up>", function() line_shift(-1) end, { silent = true })
vim.keymap.set("v", "<S-Down>", ":move '>+1<cr>gv=gv")
vim.keymap.set("v", "<S-Up>", ":move '<-2<cr>gv=gv")


-- movement
vim.keymap.set({"n", "v"}, "<tab>", "%")


-- various useful stuff
-- closing and deleting buffers
vim.keymap.set("n", "<leader>q", ":q<cr>")
vim.keymap.set("n", "<leader>d", ":bdelete<cr>")

-- highlight last inserted text
vim.keymap.set("n", "gV", "`[v`]")

-- reverse a range of line (assuming the row above is marked with t -> :help 12.4)
vim.keymap.set("n", "<leader>r", ":'t+1,.g/^/m 't<cr>")

-- tee hack to save a file even when it's opened read-only (e.g. forgetting sudo)
vim.keymap.set("c", "w!!", "w !sudo tee >/dev/null %")

-- open init.lua in home-manager
vim.keymap.set("n", "<leader>ev", ":e ~/my-home-manager/nvim/init.lua<cr>")
vim.keymap.set("n", "<leader>eV", ":vsp ~/my-home-manager/nvim/init.lua<cr>")


-- insert text into the command-line for quick testing
vim.keymap.set("n", "<leader>:", "^yg_:<C-r>\"")
vim.keymap.set("v", "<leader>:", "y:<C-r>\"")


-- Neo 2 adjustments
vim.keymap.set("", "s", "h")
vim.keymap.set("", "h", "s")
vim.keymap.set("", "n", "(v:count == 0 ? 'gj' : 'j')", { expr = true })
vim.keymap.set("", "j", "n")
vim.keymap.set("", "r", "(v:count == 0 ? 'gk' : 'k')", { expr = true })
vim.keymap.set("", "k", "r")
vim.keymap.set("", "t", "l")
vim.keymap.set("", "l", "t")

vim.keymap.set("", "S", "H")
vim.keymap.set("", "H", "S")
vim.keymap.set("", "N", "J")
vim.keymap.set("", "J", "N")
vim.keymap.set("", "R", "K")
vim.keymap.set("", "K", "R")
vim.keymap.set("", "T", "L")
vim.keymap.set("", "L", "T")
