local function edit(type)
  vim.cmd([[split $HOME/.dotfiles/nvim/lua/snippets/]]..type..[[.lua]])
end

local function edit_with_prompt()
  vim.ui.input({ prompt ="File Type: " }, function(type)
    edit(type)
  end)
end

local function edit_current_file_type()
  local filetype = vim.bo.filetype

  if filetype == "" then
    edit_with_prompt()
  else
    edit(filetype)
  end
end

return {
  edit_with_prompt = edit_with_prompt,
  edit_current_file_type = edit_current_file_type
}
