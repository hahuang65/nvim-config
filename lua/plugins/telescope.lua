-- https://github.com/nvim-telescope/telescope.nvim

local actions = require('telescope.actions')
require('telescope').setup{
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

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

vim.keymap.set('n', '<leader><leader>', require("finders").project_files,                       { desc = 'Search Project/Files' })
vim.keymap.set('n', '<leader>sb',       require('telescope.builtin').buffers,                   { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>sf',       require('telescope.builtin').find_files,                { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh',       require('telescope.builtin').help_tags,                 { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>*',        require('telescope.builtin').grep_string,               { desc = 'Search current word' })
vim.keymap.set('n', '<leader>/',        require('telescope.builtin').current_buffer_fuzzy_find, { desc = 'Search Project via grep' })
vim.keymap.set('n', '<leader>?',        require('telescope.builtin').live_grep,                 { desc = 'Search current file' })

vim.keymap.set('n', '<leader>sd', function()
  require('telescope.builtin').diagnostics({ bufnr = true })
end, { desc = '[S]earch [D]iagnostics' })
