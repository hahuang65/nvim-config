local opt = require('utils').opt
local augroup = require('utils').augroup

opt('o', 'backspace', 'indent,eol,start')         -- Allows backspace to delete everything
opt('o', 'hidden', true)                          -- Allows hiding a buffer without saving
opt('b', 'formatoptions', vim.bo.formatoptions .. 'j') -- Makes joining comment lines smarter

-- Colorscheme
vim.cmd [[ syntax enable ]]
vim.cmd [[ colorscheme dracula ]]

opt('o', 'termguicolors', true)   -- Enables 24-bit RGB in the TUI. Uses `gui` highlights instead of `cterm`.
opt('o', 'background', 'dark')

-- File Formats
opt('o', 'encoding', 'utf-8')
opt('o', 'fileformats', 'unix,dos,mac')

-- Responsiveness
opt('o', 'updatetime', 50)  -- Faster intervales between CursorHold events
opt('o', 'timeoutlen', 250) -- Shorter time (in ms) to press mapped sequences
opt('o', 'ttimeoutlen', -1) -- Shorter time (in ms) to wait for keycode sequences. -1 uses `timeoutlen` value

-- Interface
opt('o', 'lazyredraw', true)     -- Don't redraw for macros and commands that aren't typed
opt('o', 'showmatch', true)      -- Briefly show the matching bracket/paren when cursor moves onto one
opt('w', 'number', true)         -- Show line numbers
opt('w', 'relativenumber', true) -- Shows relative line numbers based on current line
opt('w', 'cursorline', true)     -- Highlights the current line
opt('w', 'signcolumn', 'auto:2') -- Autosize the signcolumn (the number sets the max items)

-- Per-Project Config
opt('o', 'exrc', true)  -- Enables per-directory vim configuration files
opt('o', 'secure', true) -- Disables autocmd, shell, and write commands in per-directory configs

-- Swap & Backup Files
opt('o', 'backup', false)
opt('o', 'writebackup', false)
opt('b', 'swapfile', false)

-- Indentation
opt('o', 'smarttab', true)   -- Use `shiftwidth` when inserting tabls at front of the line
opt('b', 'expandtab', true)  -- Use soft-tabs
opt('b', 'autoindent', true) -- Auto-indent new lines based on previous lines
opt('o', 'smartindent', true) -- Syntax-aware indentation (i.e. matching brackets and parents)
opt('b', 'shiftwidth', 2)    -- Use 2 spaces per indent
opt('b', 'softtabstop', 2)   -- Use 2 spaces per tab
opt('b', 'tabstop', 2)       -- Use tabs of size 2

-- Line Breaks
opt('w', 'colorcolumn', '80') -- Show a column guide at line 80
opt('w', 'list', false)       -- Do not display visual tabs and spaces
opt('w', 'wrap', false)       -- Don't wrap lines automatically
opt('b', 'textwidth', 0)      -- Disable linebreaks by line size
opt('b', 'wrapmargin', 0)      -- Disable linebreaks by window borders

-- Search
opt('o', 'incsearch', true)  -- Search-as-you-type
opt('o', 'ignorecase', true) -- Ignore casing during search, must be set for `smartcase`
opt('o', 'smartcase', true)  -- Case sensitivity based on searched text
opt('b', 'infercase', true)  -- `smartcase` but for completion results

-- Scrolling
opt('o', 'scrolloff', 20)     -- Start scrolling the window when 20 lines away from the top/bottom margins
opt('o', 'sidescrolloff', 20) -- Start scrolling the window when 20 lines away from the side margins
opt('o', 'sidescroll', 1)     -- Scroll by 1 horizontally at the edges of the window

-- Splits
opt('o', 'splitbelow', true) -- Split to the bottomw, instead of above
opt('o', 'splitright', true) -- Split to the right, instead of left

-- Completion
opt('o', 'completeopt', 'menuone,noselect')    -- Improve completion pop-up UX
opt('o', 'shortmess', vim.o.shortmess .. 'cI') -- Skip completion pop-up messages and startup screen

-- Undo
opt('b', 'undofile', true) -- Enable undo

-- netrw
vim.g.netrw_banner    = 0   -- Disable the banner
vim.g.netrw_winsize   = -30 -- Fixed-width for sidepane
vim.g.netrw_liststyle = 3   -- Tree-view

-- Auto Reload
opt('o', 'autoread', true)
augroup('autoreload', {
  'FocusGained, BufEnter * silent! checktime'
})

-- Terminal
augroup('terminal', {
  'TermOpen * setlocal nonumber norelativenumber signcolumn=no',
  'TermOpen * nnoremap <buffer> <C-c> i<C-c>'
})

-- Active Window
augroup('active_window', {
  'WinEnter,BufEnter * setlocal cursorline',
  'WinLeave,BufLeave * setlocal nocursorline'
})

-- Auto Source Config Files
augroup('nvim_config', {
  'BufWritePost $MYVIMRC nested source $MYVIMRC',
  'BufWritePost */nvim/**/*.lua PackerCompile'
})
