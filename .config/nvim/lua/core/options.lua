-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Relative line numbers but absolute for current line
vim.o.relativenumber = true
vim.wo.number = true

vim.o.backspace = "indent,eol,start" -- allow backspace everything in insert
vim.o.showmatch = true -- show matching braces when over one
-- Use system clipboard
vim.cmd([[set clipboard+=unnamedplus]])
-- vim.o.clipboard = "unnamedplus"

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Don't backup
vim.o.writebackup = false
vim.opt.swapfile = false
vim.opt.backup = false
-- Save undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 100 -- Default 4000 is a bit high for async updates

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- from primeagen
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.opt.scrolloff = 8
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.o.hlsearch = false -- Highlight searches
vim.opt.incsearch = true

-- Set colorscheme and true colors
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.colorcolumn = "88"

vim.opt.splitbelow = true
vim.opt.splitright = true

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Lightline shows this already
vim.o.showmode = false
-- Show last status
vim.o.laststatus = 3
-- Show command at all time until flicker is fixed with neovim 0.8
vim.o.cmdheight = 1
-- Indentation configuration
vim.o.autoindent = true
-- Hide buffers instead of closing them
vim.o.hidden = true
-- Don't beep
vim.o.visualbell = true -- Don't beep
vim.o.t_vb = nil
vim.o.errorbells = false -- Don't beep
vim.o.concealcursor = nil -- Never conceal anything on current line
vim.o.lazyredraw = true -- Speedup large files and macros
-- Intuitive default split directions
vim.o.showtabline = 2 -- Always show tabline
vim.o.shortmess = vim.o.shortmess .. "c" -- Don't give ins-completion-menu messages
vim.o.signcolumn = "yes" -- Always show signcolumn

vim.o.t_8f = "[38;2;%lu;%lu;%lum"
vim.o.t_8b = "[48;2;%lu;%lu;%lum"
vim.cmd([[filetype plugin on]])
vim.opt.background = "dark"

-- Don't auto break my lines
vim.cmd([[
    set formatoptions=cqronlj
]])
