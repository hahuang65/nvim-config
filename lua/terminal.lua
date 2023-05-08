local terminals = {}
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local function create_terminal(name, split)
  cmd(split .. "new +terminal")
  cmd("startinsert")
  local bufnr = api.nvim_get_current_buf()
  terminals[name] = bufnr
  vim.b.term_title = name

  return bufnr
end

local function attach_terminal(bufnr, split)
  cmd(split .. "new +startinsert")
  local winnr = fn.win_getid()
  api.nvim_win_set_buf(winnr, bufnr)
end

ToggleTerminal = function(name, split)
  split = split or ""

  local bufnr = terminals[name]
  if bufnr and api.nvim_buf_is_valid(bufnr) then -- Buffer is available
    local winnr = fn.bufwinid(bufnr)
    if winnr == -1 then                          -- Window is hidden
      attach_terminal(bufnr, split)
    elseif fn.win_getid() == winnr then          -- Window is visible and focused
      api.nvim_win_hide(winnr)
    elseif api.nvim_win_is_valid(winnr) then     -- Window is visible but not focused
      fn.win_gotoid(winnr)
      cmd("startinsert")
    end
  elseif bufnr then -- Buffer was deleted at some point
    terminals[name] = create_terminal(name, split)
  else              -- No such terminal yet, no buffer number
    create_terminal(name, split)
  end
end

cmd("command -nargs=1 Terminal lua ToggleTerminal(<f-args>)")
cmd("command -nargs=1 Vterminal lua ToggleTerminal(<f-args>, 'v')")
