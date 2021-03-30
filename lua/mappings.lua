local map = vim.api.nvim_set_keymap

vim.g.mapleader = ' '

-- Completion
map('i', '<Tab>',   '<Plug>(completion_smart_tab)',   {})
map('i', '<S-Tab>', '<Plug>(completion_smart_s_tab)', {})

-- Terminal
map('t', '<Esc>',  '<C-\\><C-n>',       { noremap = true })
map('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true })
map('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true })
map('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true })
map('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true })
