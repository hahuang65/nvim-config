return {
  "rachartier/tiny-devicons-auto-colors.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  config = function()
    local theme_colors = require("catppuccin.palettes").get_palette(require("common").catppuccin_palette)
    require("tiny-devicons-auto-colors").setup({
      colors = theme_colors,
    })
  end,
}
