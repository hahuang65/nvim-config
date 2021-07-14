-- https://github.com/takac/vim-hardtime

local g = vim.g

g.hardtime_default_on = 1
g.hardtime_allow_different_key = 1
g.hardtime_ignore_quickfix = 1
g.list_of_normal_keys = { "h", "j", "k", "l" }
g.list_of_visual_keys = { "h", "j", "k", "l" }
g.list_of_disabled_keys = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" }

require('augroup').create('hardtime', {
  'FileType fugitive HardTimeOff',
  'FileType NvimTree HardTimeOff',
  'FileType help HardTimeOff'
})
