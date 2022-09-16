local function new_branch()
  vim.ui.input({ prompt = "New Branch:" }, function(name)
    if name then
      vim.cmd([[Git new ]]..name)
    end
  end)
end

local function change_branch()
  local branches = vim.fn.systemlist("git branches | grep --invert-match '^* '")

  vim.ui.select(branches,
    { prompt = "Select Branch:" },
    function(branch)
      if branch then
        vim.cmd([[Git change ]]..branch)
      end
    end
  )
end

return {
  new_branch = new_branch,
  change_branch = change_branch
}
