-- https://github.com/vim-test/vim-test

local map = vim.api.nvim_set_keymap

vim.cmd [[ let test#strategy = "neovim" ]]
vim.cmd [[ let test#neovim#term_position = "botright 25" ]]

map('n', '<leader>tt', ':TestLast<CR>',    { noremap = true, silent = true })
map('n', '<leader>tn', ':TestNearest<CR>', { noremap = true, silent = true })
map('n', '<leader>tf', ':TestFile<CR>',    { noremap = true, silent = true })
map('n', '<leader>ta', ':TestSuite<CR>',   { noremap = true, silent = true })
map('n', '<leader>tv', ':TestVisit<CR>',   { noremap = true, silent = true })
