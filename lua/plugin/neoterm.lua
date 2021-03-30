-- https://github.com/kassio/neoterm

local map = vim.api.nvim_set_keymap

vim.g.neoterm_autoinsert = 1
vim.g.neoterm_default_mod = 'botright vertical'

map('n', '<leader>s', ":<C-u>exec v:count.'Ttoggle'<CR>", { noremap = true, silent = true })
map('n', '<leader>S', ":<C-u>exec 'botright '.v:count.'Ttoggle'<CR>", { noremap = true, silent = true })
