-- https://github.com/TaDaa/vimade

vim.g.vimade = {
  enabletreesitter = 1 -- Highlighting support for nvim-treesitter
}

require('utils').augroup('vimade', {
  'FileType UltestSummary VimadeBufDisable',
  'FileType fugitive VimadeBufDisable',
  'FileType NvimTree VimadeBufDisable',
  'TermOpen * VimadeBufDisable'
})
