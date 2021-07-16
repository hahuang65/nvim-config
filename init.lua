local augroup = require('augroup')

vim.g.mapleader = ' '

vim.cmd [[ syntax enable ]]
vim.cmd [[ filetype plugin on ]]
vim.cmd [[ colorscheme dracula ]]

require('language/ruby')
require('make')
require('netrw')
require('options')
require('plugins')
require('terminal')
require('quickfix')

-- Auto Reload
augroup.create('autoreload', {
  'FocusGained, BufEnter * silent! checktime'
})

-- Active Window
augroup.create('active_window', {
  'WinEnter,BufEnter * if &buftype != "terminal" | setlocal cursorline cursorcolumn | endif',
  'WinLeave,BufLeave * setlocal nocursorline nocursorcolumn'
})

-- Highlight text on yank
augroup.create('yank_highlight', {
  'TextYankPost * silent! lua vim.highlight.on_yank()'
})

-- Auto Source Config Files
augroup.create('nvim_config', {
  'BufWritePost $MYVIMRC nested source $MYVIMRC',
  'BufWritePost */nvim/**/*.lua PackerCompile'
})
