-- https://github.com/ttys3/nvim-blamer.lua

require'nvim-blamer'.setup({
    enable = true,
    prefix = '    ',
    format = '%committer • %committer-time-human • %summary',
})

vim.fn['nvimblamer#auto']()
