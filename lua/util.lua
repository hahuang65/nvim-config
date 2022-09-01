function Paste()
  vim.ui.input({ prompt = "New Paste:" }, function(name)
    local url = vim.cmd([['<,'>w ! pst -u -n ]]..name..'.'..vim.bo.filetype)
    print(url)
  end)
end

function NewBranch()
  vim.ui.input({ prompt = "New Branch:" }, function(name)
    if name then
      vim.cmd([[Git new ]]..name)
    end
  end)
end

function ChangeBranch()
  local branches = vim.fn.systemlist("git branches | grep --invert-match '^* '")

  vim.ui.select(branches,
    { prompt = "Select Branch:" },
    function(branch)
      if branch then
        vim.cmd([[Git change ]]..branch)
      end
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
