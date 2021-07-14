local A = {}

function A.create(name, autocmds)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')
  for _, autocmd in ipairs(autocmds) do
    vim.cmd('autocmd ' .. autocmd)
  end
  vim.cmd('augroup END')
end

return A
