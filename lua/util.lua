local function toggle_quickfix()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd "copen"
  end
end

local function paste()
  vim.ui.input({ prompt = "New Paste (omit extension): " }, function(name)
    local url = vim.cmd([['<,'>w ! pst -u -n ]]..name..'.'..vim.bo.filetype)
    print(url)
  end)
end

local function filetype_icon(filename, extension)
  local ok,devicons = pcall(require,'nvim-web-devicons')
  if not ok then print('No icon plugin found. Please install \'kyazdani42/nvim-web-devicons\'') return '' end
  Icon = devicons.get_icon(filename, extension) or ''
  return Icon
end

local function filename()
  if vim.b.term_title then
    return vim.b.term_title
  else
    local shortname = vim.fn.expand('%:t')

    if vim.fn.empty(shortname) == 1 then
      return '[No Name]'
    end

    local name = vim.fn.expand('%')
    local extension = vim.fn.expand('%:e')
    local readonly = ''

    if vim.bo.filetype == 'help' then
      readonly = ''
    elseif vim.bo.readonly == true then
      readonly = ' ' .. filetype_icon(shortname, extension)
    else
      readonly = ''
    end

    if string.len(readonly) ~= 0 then
      return name .. readonly
    end

    if vim.bo.modifiable then
      if vim.bo.modified then
        return name .. ' ' .. ''
      end
    end
    return name

  end
end

return {
  filename = filename,
  filetype_icon = filetype_icon,
  paste = paste,
  toggle_quickfix = toggle_quickfix
}
