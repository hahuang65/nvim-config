-- https://github.com/catppuccin/nvim

local catppuccin = require("catppuccin")

catppuccin.setup {
  compile = {
    enabled = true,
    path = vim.fn.stdpath "cache" .. "/catppuccin"
  },
  dim_inactive = {
		enabled = false,
		shade = "dark",
		percentage = 0.15,
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
    treesitter = true,
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
    lsp_trouble = false,
    cmp = true,
    lsp_saga = false,
    gitgutter = false,
    gitsigns = true,
    telescope = true,
    nvimtree = {
      enabled = true,
      show_root = false,
    },
    which_key = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = true,
    },
    dashboard = false,
    neogit = false,
    vim_sneak = false,
    fern = false,
    barbar = false,
    bufferline = false,
    markdown = true,
    lightspeed = false,
    ts_rainbow = false,
    hop = false,
    notify = false,
    telekasten = false,
  }
}

vim.cmd[[colorscheme catppuccin]]
