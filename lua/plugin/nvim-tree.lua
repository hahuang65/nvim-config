-- https://github.com/kyazdani42/nvim-tree.lua

require'nvim-tree'.setup {
  disable_netrw = true,
  auto_close = true,
  update_cwd = true,
  update_focused_file = {
    enable = true
  }
}

vim.g.nvim_tree_ignore = { '.git', 'node_modules' } -- Ignore certain subdirectories/files
vim.g.nvim_tree_indent_markers = 1                  -- Show indentation markers for subdirectories
vim.g.nvim_tree_add_trailing = 1                    -- Adds a trailing `/` to denote directories
vim.g.nvim_tree_group_empty = 1                     -- If a directory has a single child, combine into 1 entry
vim.g.nvim_tree_quit_on_open = 1                    -- Closes tree when opening a file
