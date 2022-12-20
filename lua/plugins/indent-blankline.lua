-- https://github.com/lukas-reineke/indent-blankline.nvim

require("indent_blankline").setup {
  use_treesitter = true,
  filetype_exclude = { 'help' },
  buftype_exclude = { 'terminal' },
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
}
