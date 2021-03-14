require'nvim-blamer'.setup({
    enable = true,
    prefix = '    ',
    format = '%committer │ %committer-time-human │ %summary',
})

vim.fn['nvimblamer#auto']()
