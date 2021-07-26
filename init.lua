vim.g.mapleader = ' '

vim.cmd [[ syntax enable ]]
vim.cmd [[ filetype plugin on ]]

-- Built-ins
require('netrw')
require('options')

-- Custom
require('terminal')

-- Plugins
require('plugins')

-- Post-plugins
require('keymaps')
require('autocommands')
