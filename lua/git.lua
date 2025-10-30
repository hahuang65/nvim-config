local function strip_ansi_codes(str)
  -- Remove ANSI escape codes (color codes, etc)
  return str:gsub("\27%[[%d;]*m", "")
end

local function git_command(args)
  local cmd = "git " .. args
  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Git command failed: " .. strip_ansi_codes(result), vim.log.levels.ERROR)
  else
    if result and result ~= "" then
      vim.notify(strip_ansi_codes(result), vim.log.levels.INFO)
      require("neogit").dispatch_refresh()
    end
  end
end

local function new_branch()
  vim.ui.input({ prompt = "New Branch:" }, function(name)
    if name then
      git_command("new " .. vim.fn.shellescape(name))
    end
  end)
end

local function neogit_is_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_is_valid(buf) then
      local ft = vim.bo[buf].filetype
      if ft:match("^Neogit") or ft:match("^NeogitStatus") then
        return true
      end
    end
  end

  return false
end

local function toggle_neogit()
  local neogit = require("neogit")

  if neogit_is_open() then
    neogit.close()
  else
    neogit.open({ kind = "auto" })
  end
end

-- Create the :Git command
vim.api.nvim_create_user_command("Git", function(opts)
  git_command(opts.args)
end, { nargs = "+", desc = "Execute git command" })

return {
  git_command = git_command,
  new_branch = new_branch,
  toggle_neogit = toggle_neogit,
}
