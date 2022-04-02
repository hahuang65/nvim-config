function Paste()
  vim.ui.input({ prompt ="Paste Name: " }, function(name)
    local url = vim.cmd([['<,'>w ! pst -u -n ]]..name..'.'..vim.bo.filetype)
    print(url)
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
  filetype = vim.bo.filetype

  if filetype == "" then
    EditSnippetsPromptFiletype()
  else
    EditSnippets(filetype)
  end
end
