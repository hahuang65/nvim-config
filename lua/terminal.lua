local map = vim.api.nvim_set_keymap

map('n', '<leader>s', ':vsplit | terminal<CR>', { noremap = true })
map('n', '<leader>S', ':split | terminal<CR>',  { noremap = true })

map('t', '<Esc>',  '<C-\\><C-n>',       { noremap = true })
map('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true })
map('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true })
map('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true })
map('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true })

require('augroup').create('terminal', {
  'TermOpen * setlocal nonumber norelativenumber nocursorline nocursorcolumn signcolumn=no',
  'TermOpen * nnoremap <buffer> <C-c> i<C-c>',
  'TermOpen * startinsert',
  'TermClose * call nvim_input("<CR>")' -- Closes the terminal once the shell is exited
})
