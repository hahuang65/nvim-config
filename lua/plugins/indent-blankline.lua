-- https://github.com/lukas-reineke/indent-blankline.nvim

return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  opts = {
    scope = {
      enabled = true,
      show_start = true,
    },
    exclude = {
      filetypes = { "help", "lazy", "mason" },
      buftypes = { "terminal" },
    },
  },
}
