-- https://github.com/catppuccin/nvim

return {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      local catppuccin = require("catppuccin")
      vim.g.catppuccin_flavour = "mocha"

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
          integrations = {
              cmp = true,
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
              treesitter = true,
              treesitter_context = true,
              telescope = true,
          },
      })

      vim.cmd([[colorscheme catppuccin]])
      vim.api.nvim_set_hl(0, 'CursorColumn', { link = 'CursorLine' })
    end,
}
