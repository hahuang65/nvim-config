-- https://github.com/rcarriga/vim-ultest

local utils = require('utils')
local map = vim.api.nvim_set_keymap

map('n', '<leader>tn', ':call ultest#run_nearest() <bar> UltestSummaryOpen<CR>', { noremap = true, silent = true })
map('n', '<leader>tf', ':call ultest#run_file() <bar> UltestSummaryOpen<CR>',    { noremap = true, silent = true })
map('n', '<leader>to', ':UltestOutput<CR>',                                      { noremap = true, silent = true })
map('n', '<leader>td', ':UltestAttach<CR>',                                      { noremap = true, silent = true })
map('n', '<leader>ts', ':UltestSummary<CR>',                                     { noremap = true, silent = true })
map('n', ']t',         '<Plug>(ultest-next-fail)',                               {})
map('n', '[t',         '<Plug>(ultest-prev-fail)',                               {})

utils.augroup('ultest', {
    'FileType UltestSummary setlocal nofoldenable',
    'FileType UltestSummary VimadeBufDisable',
    'BufWritePost * UltestNearest'
})

-- Dracula colors
vim.cmd [[ hi UltestPass ctermfg=Green guifg=#50FA7B ]]
vim.cmd [[ hi UltestFail ctermfg=Red guifg=#FF5555 ]]
vim.cmd [[ hi UltestRunning ctermfg=Yellow guifg=#F1FA8C ]]
vim.cmd [[ hi UltestBorder ctermfg=Red guifg=#FF5555 ]]
vim.cmd [[ hi UltestInfo ctermfg=cyan guifg=#8BE9FD cterm=bold gui=bold ]]

