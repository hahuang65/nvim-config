-- https://github.com/mhanberg/output-panel.nvim

return {
  "mhanberg/output-panel.nvim",
  event = "VeryLazy",
  config = function()
    require("output_panel").setup()
  end,
}
