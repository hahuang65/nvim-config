-- https://github.com/tpope/vim-fugitive
-- https://github.com/pwntester/octo.nvim

local map = vim.api.nvim_set_keymap

-- Conflicts
map('n', 'd[', ':diffget //2 | :diffupdate<CR>',       { noremap = true })
map('n', 'd]', ':diffget //3 | :diffupdate<CR>',       { noremap = true })

map('n', '<leader>gA',  ':Git amend<CR>',         { noremap = true })
map('n', '<leader>gg',  ':Git<CR>',               { noremap = true })
map('n', '<leader>gP',  ':Git publish<CR>',       { noremap = true })
map('n', '<leader>gR',  ':Git retrunk<CR>',       { noremap = true })
map('n', '<leader>gS',  ':Git sync<CR>',          { noremap = true })
map('n', '<leader>pr',  ':Octo review start<CR>', { noremap = true })
