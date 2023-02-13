-- https://github.com/folke/todo-comments.nvim

return {
  "folke/todo-comments.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "catppuccin/nvim",
  },
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo comment",
    },
    { "<leader>st", ":TodoTelescope<CR>", desc = "[S]earch [T]ODOs" },
  },
  config = function()
    local C = require("catppuccin.palettes").get_palette()

    require("todo-comments").setup({
      signs = false,
      colors = {
        error = { "DiagnosticError", "ErrorMsg", C.red },
        warning = { "DiagnosticWarn", "WarningMsg", C.yellow },
        info = { "DiagnosticInfo", C.sapphire },
        hint = { "DiagnosticHint", C.green },
        default = { "Identifier", C.peach },
        test = { "Identifier", C.lavender },
      },
    })
  end,
}
