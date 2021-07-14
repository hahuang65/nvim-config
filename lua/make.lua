local map = vim.api.nvim_set_keymap

map('n', '<leader>m:', ':make! ',                           { noremap = true })
map('n', '<leader>ma', ':make!<CR>',                        { noremap = true })
map('n', '<leader>mf', ':lmake! %<CR>',                     { noremap = true })
map('n', '<leader>mm', ':lmake! %:<C-r>=line(".")<CR><CR>', { noremap = true })
