-- https://github.com/anuvyklack/fold-preview.nvim

return {
  "anuvyklack/fold-preview.nvim",
  keys = {
    {
      "Z",
      function()
        require("fold-preview").toggle_preview()
      end,
      mode = { "n" },
      desc = "Preview fold",
    },
  },
  config = function()
    require("fold-preview").setup({
      auto = false,
      default_keybindings = false,
      border = require("signs").border,
    })
  end,
}
