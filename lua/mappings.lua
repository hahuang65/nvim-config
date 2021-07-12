local map = vim.api.nvim_set_keymap

vim.g.mapleader = ' '

-- nvim-compe
vim.g.lexima_no_default_rules = true
vim.fn['lexima#set_default_rules']()

map('i', '<C-Space>', [[compe#complete()]],                             { silent = true, expr = true, noremap = true })
map('i', '<CR>',      [[compe#confirm(lexima#expand('<LT>CR>', 'i'))]], { silent = true, expr = true, noremap = true })
map('i', '<C-e>',     [[compe#close('<C-e>')]],                         { silent = true, expr = true, noremap = true })
map('i', '<C-f>',     [[compe#scroll({ 'delta': +4 })]],                { silent = true, expr = true, noremap = true })
map('i', '<C-d>',     [[compe#scroll({ 'delta': -4 })]],                { silent = true, expr = true, noremap = true })

-- Terminal
map('t', '<Esc>',  '<C-\\><C-n>',       { noremap = true })
map('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true })
map('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true })
map('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true })
map('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true })

-- Testing
map('n', '<leader>tf', ':make! %<CR>', { noremap = true })
map('n', '<leader>ta', ':make!<CR>', { noremap = true })
map('n', '<leader>tt', ':make! %:<C-r>=line(".")<CR><CR>', { noremap = true })
