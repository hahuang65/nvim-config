-- https://github.com/tpope/vim-fugitive

local map = vim.api.nvim_set_keymap

map('n', '<leader>gA', ':Git amend<CR>',                       { noremap = true })
map('n', '<leader>gg', ':Git<CR>',                             { noremap = true })
map('n', '<leader>gP', ':Git publish<CR>',                     { noremap = true })
map('n', '<leader>gR', ':Git retrunk<CR>',                     { noremap = true })
map('n', '<leader>gS', ':Git sync<CR>',                        { noremap = true })
map('n', '<leader>pr', ':Git pr create --fill --web<CR>',      { noremap = true })
