-- https://github.com/vim-test/vim-test

vim.g['test#strategy'] = 'make'
vim.cmd [[let test#python#runner = "pytest"]]
