-- https://github.com/lewis6991/gitsigns.nvim

require('gitsigns').setup {
  signs                        = {
    add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
  signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked          = true,
  current_line_blame           = true,
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '  <abbrev_sha> • <author> • <author_time> • <summary>',
  sign_priority                = 6,
  update_debounce              = 100,
  status_formatter             = nil, -- Use default
  max_file_length              = 40000,
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm                         = {
    enable = false
  },
}

vim.keymap.set('n', ']h', [[&diff ? ']h' : '<cmd>lua require('gitsigns').next_hunk()<CR>']],
  { desc = 'Next Git Hunk', expr = true })
vim.keymap.set('n', '[h', [[&diff ? '[h' : '<cmd>lua require('gitsigns').prev_hunk()<CR>']],
  { desc = 'Previous Git Hunk', expr = true })
vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { desc = 'Reset Hunk' })
vim.keymap.set('n', '<leader>g?', require('gitsigns').preview_hunk, { desc = 'Preview Hunk' })
vim.keymap.set({ 'o', 'x' }, 'ih', ":<C-U>lua require('gitsigns.actions').select_hunk()<CR>",
  { desc = 'Select Git Hunk' })
