-- https://github.com/takac/vim-hardtime

vim.g.hardtime_default_on = 1
vim.g.hardtime_allow_different_key = 1
vim.g.list_of_normal_keys = { "h", "j", "k", "l" }
vim.g.list_of_visual_keys = { "h", "j", "k", "l" }
vim.g.list_of_disabled_keys = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" }

require('utils').augroup('hardtime', {
  'FileType fugitive HardTimeOff',
  'FileType NvimTree HardTimeOff'
})
