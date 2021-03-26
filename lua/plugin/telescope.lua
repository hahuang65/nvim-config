-- https://github.com/nvim-telescope/telescope.nvim

local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  }
}

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

vim.api.nvim_set_keymap('n', '<leader><leader>', [[<cmd>lua find_project_files()<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>/', [[<cmd>Telescope live_grep<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>b', [[<cmd>Telescope buffers<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>c', [[<cmd>lua find_vim_config()<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>d', [[<cmd>lua find_dotfiles()<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>f', [[<cmd>Telescope find_files<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gg', [[<cmd>Telescope git_status<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gb', [[<cmd>Telescope git_branches<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gc', [[<cmd>Telescope git_bcommits<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gC', [[<cmd>Telescope git_commits<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>h', [[<cmd>Telescope help_tags<CR>]], { noremap = true })

-- telescope-project
vim.api.nvim_set_keymap('n', '<leader>pp', ":lua require'telescope'.extensions.project.project{}<CR>", {noremap = true, silent = true})
