function Paste()
  vim.ui.input({ prompt = "Paste Name: " }, function(name)
    local url = vim.cmd([['<,'>w ! pst -u -n ]]..name..'.'..vim.bo.filetype)
    print(url)
  end)
end

function NewBranch()
  vim.ui.input({ prompt = "Branch Name: " }, function(name)
    vim.cmd([[Git new ]]..name)
    vim.cmd([[message clear]])
  end)
end
local function EditSnippets(type)
  vim.cmd([[split $HOME/.dotfiles/nvim/lua/snippets/]]..type..[[.lua]])
end

function EditSnippetsPromptFiletype()
  vim.ui.input({ prompt ="File Type: " }, function(type)
    EditSnippets(type)
  end)
end

function EditSnippetsCurrentFiletype()
  local filetype = vim.bo.filetype

  if filetype == "" then
    EditSnippetsPromptFiletype()
  else
    EditSnippets(filetype)
  end
end

function Filename()
  if vim.b.term_title then
    return vim.b.term_title
  else
    local shortname = vim.fn.expand('%:t')

    if vim.fn.empty(shortname) == 1 then
      return '[No Name]'
    end

    local filename = vim.fn.expand('%')
    local extension = vim.fn.expand('%:e')
    local readonly = ''

    if vim.bo.filetype == 'help' then
      readonly = ''
    elseif vim.bo.filetype == 'gitcommit' then
      filename = shortname
    elseif vim.bo.filetype == 'fugitive' then
      filename = "Git"
    elseif vim.bo.filetype == 'NvimTree' then
      filename = "Files"
    elseif vim.bo.readonly == true then
      readonly = ' ' .. FiletypeIcon(shortname, extension)
    else
      readonly = ''
    end

    if string.len(readonly) ~= 0 then
      return filename .. readonly
    end

    if vim.bo.modifiable then
      if vim.bo.modified then
        return filename .. ' ' .. ''
      end
    end
    return filename

  end
end

function FiletypeIcon(filename, extension)
  local ok,devicons = pcall(require,'nvim-web-devicons')
  if not ok then print('No icon plugin found. Please install \'kyazdani42/nvim-web-devicons\'') return '' end
  Icon = devicons.get_icon(filename, extension) or ''
  return Icon
end

return {
  Filename = Filename,
  FiletypeIcon = FiletypeIcon
}
