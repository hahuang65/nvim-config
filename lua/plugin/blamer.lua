-- https://github.com/ttys3/nvim-blamer.lua

require'nvim-blamer'.setup({
    enable = true,
    prefix = '    ',
    format = '%hash-short • %committer • %committer-time-human • %summary',
})

vim.fn['nvimblamer#auto']()
