-- https://github.com/fatih/vim-go

vim.g['go_jump_to_error'] = 0
vim.g['go_fmt_fail_silently'] = 1

vim.keymap.set('n', '<leader>td', require('dap-go').debug_test, { desc = '[T]est - [D]ebug', buffer = true })
