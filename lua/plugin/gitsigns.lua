-- https://github.com/lewis6991/gitsigns.nvim

require('gitsigns').setup {
  sign_priority=100,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

    ['n <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',

    -- Text objects
    ['o ic'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
    ['x ic'] = ':<C-U>lua require"gitsigns".text_object()<CR>'
  }
}
