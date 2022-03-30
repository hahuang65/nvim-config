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

find_nvim_config = function()
    require("telescope.builtin").find_files({
        prompt_title = "Neovim Config",
        cwd = "$HOME/.dotfiles/nvim/",
    })
end

find_dotfiles = function()
    require("telescope.builtin").find_files({
        prompt_title = "Dotfiles",
        cwd = "$HOME/.dotfiles/",
    })
end

find_project_files = function(opts)
  opts = opts or  {}
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end
