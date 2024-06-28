-- https://github.com/bbjornstad/pretty-fold.nvim

return {
  "bbjornstad/pretty-fold.nvim", -- https://github.com/anuvyklack/pretty-fold.nvim/issues/39
  event = "VeryLazy",
  config = function()
    require("pretty-fold").setup()
  end,
}
