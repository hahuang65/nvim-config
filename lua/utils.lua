local U = {}
local cmd = vim.cmd

function U.augroup(name, autocmds)
  cmd('augroup ' .. name)
  cmd('autocmd!')
  for _, autocmd in ipairs(autocmds) do
    cmd('autocmd ' .. autocmd)
  end
  cmd('augroup END')
end

return U
