local function new_branch()
  vim.ui.input({ prompt = "New Branch:" }, function(name)
    if name then
      vim.cmd([[Git new ]] .. name)
    end
  end)
end

local function change_branch()
  local branches = vim.fn.systemlist("git branches | grep --invert-match '^* '")

  vim.ui.select(branches, { prompt = "Select Branch:" }, function(branch)
    if branch then
      vim.cmd([[Git change ]] .. branch)
    end
  end)
end

local function show_fugitive()
  if vim.fn.FugitiveHead() ~= "" then
    vim.cmd([[
      Git
      " wincmd H  " Open Git window in vertical split
      " vertical resize 31
      " setlocal winfixwidth
      setlocal nonumber
      setlocal norelativenumber
      ]])
  end
end

local function toggle_fugitive()
  if vim.fn.buflisted(vim.fn.bufname("fugitive:///*/.git//$")) ~= 0 then
    vim.cmd([[ execute ":bdelete" bufname('fugitive:///*/.git//$') ]])
  else
    show_fugitive()
  end
end

return {
  new_branch = new_branch,
  change_branch = change_branch,
  toggle_fugitive = toggle_fugitive,
}
