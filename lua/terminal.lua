local map = vim.api.nvim_set_keymap

local terminals = {}
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local function create_terminal(name, split)
  cmd(split..'new +terminal')
  bufnr = api.nvim_get_current_buf()
  terminals[name] = bufnr
  vim.b.term_title = name

  return bufnr
end

local function attach_terminal(bufnr, split)
  cmd(split..'new +startinsert')
  winnr = fn.win_getid()
  api.nvim_win_set_buf(winnr, bufnr)
end

function _G.toggle_terminal(name, split)
  local split = split or ''

  bufnr = terminals[name]
  if bufnr and api.nvim_buf_is_valid(bufnr) then -- Buffer is available
    local winnr = fn.bufwinid(bufnr)
    if winnr == -1 then -- Window is hidden
      attach_terminal(bufnr, split)
    elseif fn.win_getid() == winnr then -- Window is visible and focused
      api.nvim_win_hide(winnr)
    elseif api.nvim_win_is_valid(winnr) then -- Window is visible but not focused
      fn.win_gotoid(winnr)
    end
  elseif bufnr then -- Buffer was deleted at some point
    terminals[name] = create_terminal(name, split)
  else -- No such terminal yet, no buffer number
    create_terminal(name, split)
  end
end

map('n', '<leader>tc', ':call v:lua.toggle_terminal("Console")<CR>',       { noremap = true, silent = true })
map('n', '<leader>TC', ':call v:lua.toggle_terminal("Console", "v")<CR>',  { noremap = true, silent = true })
map('n', '<leader>ts', ':call v:lua.toggle_terminal("Server")<CR>',        { noremap = true, silent = true })
map('n', '<leader>TS', ':call v:lua.toggle_terminal("Server", "v")<CR>',   { noremap = true, silent = true })
map('n', '<leader>tt', ':call v:lua.toggle_terminal("Terminal")<CR>',      { noremap = true, silent = true })
map('n', '<leader>TT', ':call v:lua.toggle_terminal("Terminal", "v")<CR>', { noremap = true, silent = true })

map('t', '<Esc>',  '<C-\\><C-n>',       { noremap = true })
map('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true })
map('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true })
map('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true })
map('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true })

require('augroup').create('terminal', {
  'TermOpen * setlocal nonumber norelativenumber nocursorline nocursorcolumn signcolumn=no',
  'TermOpen * nnoremap <buffer> <C-c> i<C-c>',
  'TermOpen * startinsert',
  'TermClose * call nvim_input("<CR>")' -- Closes the terminal once the shell is exited
})
