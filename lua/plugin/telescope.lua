-- https://github.com/nvim-telescope/telescope.nvim

local map = vim.api.nvim_set_keymap
local actions = require('telescope.actions')
require('telescope').setup{
  extensions = {
    fzf = {
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case"
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

find_vim_config = function() 
    require("telescope.builtin").find_files({
        prompt_title = "Vim Config",
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

-- The 2 `g` bindings for buffer tags and tags should be overridden when LSP loads
-- This just means that tags will be used for files without LSP, and LSP symbols will be used for files with LSP.
map('n', 'g]', [[<cmd>Telescope current_buffer_tags<CR>]], { noremap = true })
map('n', 'g}', [[<cmd>Telescope tags<CR>]], { noremap = true })
map('n', 'g\\', [[<cmd>Telescope treesitter<CR>]], { noremap = true })
map('n', 't]', [[<cmd>Telescope current_buffer_tags<CR>]], { noremap = true })
map('n', 't}', [[<cmd>Telescope tags<CR>]], { noremap = true })
map('n', '<leader><leader>', [[<cmd>lua find_project_files()<CR>]], { noremap = true })
map('n', '<leader>?', [[<cmd>Telescope live_grep<CR>]], { noremap = true })
map('n', '<leader>/', [[<cmd>Telescope current_buffer_fuzzy_find<CR>]], { noremap = true })
map('n', '<leader>*', [[<cmd>Telescope grep_string<CR>]], { noremap = true })
map('n', '<leader>b', [[<cmd>Telescope buffers<CR>]], { noremap = true })
map('n', '<leader>m', [[<cmd>Telescope marks<CR>]], { noremap = true })
map('n', '<leader>r', [[<cmd>Telescope registers<CR>]], { noremap = true })
map('n', '<leader>fc', [[<cmd>lua find_vim_config()<CR>]], { noremap = true })
map('n', '<leader>fd', [[<cmd>lua find_dotfiles()<CR>]], { noremap = true })
map('n', '<leader>ff', [[<cmd>Telescope find_files<CR>]], { noremap = true })
map('n', '<leader>gs', [[<cmd>Telescope git_status<CR>]], { noremap = true })
map('n', '<leader>gb', [[<cmd>Telescope git_branches<CR>]], { noremap = true })
map('n', '<leader>gc', [[<cmd>Telescope git_bcommits<CR>]], { noremap = true })
map('n', '<leader>gC', [[<cmd>Telescope git_commits<CR>]], { noremap = true })
map('n', '<leader>hc', [[<cmd>Telescope commands<CR>]], { noremap = true })
map('n', '<leader>hh', [[<cmd>Telescope help_tags<CR>]], { noremap = true })
map('n', '<leader>hk', [[<cmd>Telescope keymaps<CR>]], { noremap = true })
map('n', '<leader>hm', [[<cmd>Telescope man_pages<CR>]], { noremap = true })
map('n', '<leader>lj', [[<cmd>Telescope jumplist<CR>]], { noremap = true })
map('n', '<leader>ll', [[<cmd>Telescope loclist<CR>]], { noremap = true })
map('n', '<leader>lq', [[<cmd>Telescope quickfix<CR>]], { noremap = true })

-- telescope-project
map('n', '<leader>pp', ":lua require'telescope'.extensions.project.project{}<CR>", {noremap = true, silent = true})
