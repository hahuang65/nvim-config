-- https://github.com/j-hui/fidget.nvim
return {
  "j-hui/fidget.nvim",
  tag = "legacy",
  event = "LspAttach",
  opts = {
    text = {
      spinner = "dots",
      done = "✓",
    },
  },
}
