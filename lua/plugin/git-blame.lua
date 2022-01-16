-- https://github.com/f-person/git-blame.nvim

-- The background looking different is because of https://github.com/neovim/neovim/issues/15485
vim.g.gitblame_enabled = 1
vim.g.gitblame_message_template = '  <sha> • <author> • <date> • <summary>'
vim.g.gitblame_date_format = '%r'
vim.g.gitblame_highlight_group = "Comment"
vim.g.gitblame_set_extmark_options = { priority = 5000 } -- Needs to be at least 4100 to be after LSP diagnostics
