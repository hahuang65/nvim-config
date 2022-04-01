function Paste()
  vim.ui.input({ prompt ="Paste Name: " }, function(name)
    local url = vim.cmd([['<,'>w ! pst -u -n ]]..name..'.'..vim.bo.filetype)
    print(url)
  end)
end
