-- use{ 'anuvyklack/pretty-fold.nvim',

return {
  "anuvyklack/pretty-fold.nvim",
  event = "VeryLazy",
  config = function()
    require("pretty-fold").setup()
  end,
}
