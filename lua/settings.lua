local o = vim.o
local w = vim.wo
local b = vim.bo

local utils = require('utils')

o.backspace     = 'indent,eol,start'     -- Allows backspace to delete everything
o.hidden        = true                   -- Allows hiding a buffer without saving
b.formatoptions = b.formatoptions .. 'j' -- Makes joining comment lines smarter

-- Colorscheme
vim.cmd [[ syntax enable ]]
vim.cmd [[ colorscheme dracula ]]

o.termguicolors = true   -- Enables 24-bit RGB in the TUI. Uses `gui` highlights instead of `cterm`.
o.background    = 'dark'

-- File Formats
o.encoding    = 'utf-8'
o.fileformats = 'unix,dos,mac'

-- Responsiveness
o.updatetime  = 50  -- Faster intervales between CursorHold events
o.timeoutlen  = 250 -- Shorter time (in ms) to press mapped sequences
o.ttimeoutlen = -1  -- Shorter time (in ms) to wait for keycode sequences. -1 uses `timeoutlen` value

-- Interface
o.lazyredraw     = true     -- Don't redraw for macros and commands that aren't typed
o.showmatch      = true     -- Briefly show the matching bracket/paren when cursor moves onto one
w.number         = true     -- Show line numbers
w.relativenumber = true     -- Shows relative line numbers based on current line
w.cursorline     = true     -- Highlights the current line
w.signcolumn     = 'auto:4' -- Autosize the signcolumn (the number sets the max items)

-- Per-Project Config
o.exrc   = true -- Enables per-directory vim configuration files
o.secure = true -- Disables autocmd, shell, and write commands in per-directory configs

-- Swap & Backup Files
o.backup      = false
o.writebackup = false
b.swapfile    = false

-- Indentation
o.smarttab    = true -- Use `shiftwidth` when inserting tabls at front of the line
b.expandtab   = true -- Use soft-tabs
b.autoindent  = true -- Auto-indent new lines based on previous lines
b.smartindent = true -- Syntax-aware indentation (i.e. matching brackets and parents)
b.shiftwidth  = 2    -- Use 2 spaces per indent
b.softtabstop = 2    -- Use 2 spaces per tab
b.tabstop     = 2    -- Use tabs of size 2

-- Line Breaks
-- o.listchars = o.listchars .. 'precedes:<,extends:>'
w.colorcolumn = '80'  -- Show a column guide at line 80
w.list        = false -- Do not display visual tabs and spaces
w.wrap        = false -- Don't wrap lines automatically
b.textwidth   = 0     -- Disable linebreaks by line size
b.wrapmargin  = 0     -- Disable linebreaks by window borders

-- Search
o.incsearch = true -- Search-as-you-type
o.smartcase = true -- Case sensitivity based on searched text
b.infercase = true -- `smartcase` but for completion results

-- Scrolling
o.scrolloff     = 20 -- Start scrolling the window when 20 lines away from the top/bottom margins
o.sidescrolloff = 20 -- Start scrolling the window when 20 lines away from the side margins
o.sidescroll    = 1  -- Scroll by 1 horizontally at the edges of the window

-- Splits
o.splitbelow = true -- Split to the bottomw, instead of above
o.splitright = true -- Split to the right, instead of left

-- Completion
o.completeopt = 'menuone,noinsert,noselect,preview' -- Improve completion pop-up UX
o.shortmess = o.shortmess .. 'c'                    -- Skip completion pop-up messages

-- Persistent Undo
os.execute('mkdir --parents ~/.vimundo')
o.undodir  = '~/.vimundo' -- Keeps undo history tidy in the same folder
b.undofile = true         -- Enable undo in all files

-- netrw
vim.g.netrw_banner    = 0   -- Disable the batter
vim.g.netrw_winsize   = -30 -- Fixed-width for sidepane
vim.g.netrw_liststyle = 3   -- Tree-view

-- Auto Reload
o.autoread = true
utils.augroup('autoreload', {
  'FocusGained, BufEnter * silent! checktime'
})

-- Terminal
utils.augroup('terminal', {
  'TermOpen * setlocal nonumber norelativenumber signcolumn=no',
  'TermOpen * VimadeBufDisable',
  'TermOpen * nnoremap <buffer> <C-c> i<C-c>'
})

-- Auto Source Config Files
utils.augroup('nvim_config', {
  'BufWritePost $MYVIMRC nested source $MYVIMRC',
  'BufWritePost */nvim/**/*.lua PackerCompile'
})
