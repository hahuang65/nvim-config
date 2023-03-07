-- https://github.com/lukas-reineke/indent-blankline.nvim

return {
  "lukas-reineke/indent-blankline.nvim",
  config = {
    use_treesitter = true,
    filetype_exclude = { "help", "lazy", "mason" },
    buftype_exclude = { "terminal" },
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
  },
}
