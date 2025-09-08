-- https://github.com/nvim-zh/colorful-winsep.nvim

return {
  "nvim-zh/colorful-winsep.nvim",
  event = "VeryLazy",
  config = function()
    require("colorful-winsep").setup()
  end,
}
