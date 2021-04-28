-- https://github.com/akinsho/nvim-toggleterm.lua

require"toggleterm".setup{
  size = 100,
  open_mapping = [[<C-s>]],
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 1,
  start_in_insert = true,
  persist_size = true,
  direction = 'vertical'
}
