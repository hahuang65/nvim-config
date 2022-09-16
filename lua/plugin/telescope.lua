-- https://github.com/nvim-telescope/telescope.nvim

local actions = require('telescope.actions')
require('telescope').setup{
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case"
    },
    project = {
      base_dirs = {
        '~/Documents/Projects',
        '~/.dotfiles'
      }
    }
  },
  defaults = {
    mappings = {
      n = {
        ["<C-g>"] = actions.close
      },
      i = {
        ["<C-g>"] = actions.close
      }
    }
  }
}

require('telescope').load_extension('fzf')
