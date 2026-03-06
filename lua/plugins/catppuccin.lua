-- https://github.com/catppuccin/nvim

return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    local catppuccin = require("catppuccin")
    vim.g.catppuccin_flavour = require("common").catppuccin_palette

    catppuccin.setup({
      compile = {
        enabled = true,
        path = vim.fn.stdpath("cache") .. "/catppuccin",
      },
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.10,
      },
      transparent_background = false,
      term_colors = true,
      styles = {
        comments = { "italic" },
        functions = { "bold" },
        keywords = { "underline" },
        strings = {},
        variables = {},
      },
      default_integrations = false,
      integrations = {
        blink_cmp = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
        fidget = true,
        gitsigns = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        mason = true,
        neotest = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "bold", "italic" },
            hints = { "underline" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        notify = true,
        octo = true,
        snacks = true,
        treesitter = true,
        treesitter_context = true,
      },
    })

    vim.cmd([[colorscheme catppuccin]])
    vim.api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine" })
  end,
}
