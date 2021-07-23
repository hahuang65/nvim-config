-- https://github.com/kyazdani42/nvim-tree.lua

vim.g.nvim_tree_ignore = { '.git', 'node_modules' } -- Ignore certain subdirectories/files
vim.g.nvim_tree_indent_markers = 1                  -- Show indentation markers for subdirectories
vim.g.nvim_tree_follow = 1                          -- Updates tree cursor when a buffer is entered
vim.g.nvim_tree_add_trailing = 1                    -- Adds a trailing `/` to denote directories
vim.g.nvim_tree_group_empty = 1                     -- If a directory has a single child, combine into 1 entry
