-- https://github.com/mhanberg/output-panel.nvim

return {
  "mhanberg/output-panel.nvim",
  cmd = "OutputPanel",
  event = "LspAttach",
  config = function()
    require("output_panel").setup()
  end,
}
