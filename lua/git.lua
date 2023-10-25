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
      ]])
  else
    vim.notify("Git is either in a detached state, or not initialized. Use :Git to force open", vim.log.levels.WARN)
  end
end

local function toggle_fugitive()
  if vim.fn.buflisted(vim.fn.bufname("fugitive:///*/.git//$")) ~= 0 then -- Regular git repositories
    vim.cmd([[ execute ":bdelete" bufname('fugitive:///*/.git//$') ]])
  elseif vim.fn.buflisted(vim.fn.bufname("fugitive:///*/.git/*//$")) ~= 0 then -- Nested git repositories
    vim.cmd([[ execute ":bdelete" bufname('fugitive:///*/.git/*//$') ]])
  else
    show_fugitive()
  end
end

local function commits_for_lines()
  local _, start_line, _, _ = unpack(vim.fn.getpos("v"))
  local _, end_line, _, _ = unpack(vim.fn.getpos("."))
  vim.cmd([[Git log -L ]] .. start_line .. "," .. end_line .. ":" .. vim.fn.expand("%"))
end

return {
  new_branch = new_branch,
  change_branch = change_branch,
  toggle_fugitive = toggle_fugitive,
  commits_for_lines = commits_for_lines,
}
