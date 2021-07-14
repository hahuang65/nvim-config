-- https://github.com/hrsh7th/nvim-compe

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
  };
}

vim.g.lexima_no_default_rules = true
vim.fn['lexima#set_default_rules']()

local map = vim.api.nvim_set_keymap

map('i', '<C-Space>', [[compe#complete()]],                             { silent = true, expr = true, noremap = true })
map('i', '<CR>',      [[compe#confirm(lexima#expand('<LT>CR>', 'i'))]], { silent = true, expr = true, noremap = true })
map('i', '<C-e>',     [[compe#close('<C-e>')]],                         { silent = true, expr = true, noremap = true })
map('i', '<C-f>',     [[compe#scroll({ 'delta': +4 })]],                { silent = true, expr = true, noremap = true })
map('i', '<C-d>',     [[compe#scroll({ 'delta': -4 })]],                { silent = true, expr = true, noremap = true })
