local U = {}
local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

function U.augroup(name, autocmds)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')
  for _, autocmd in ipairs(autocmds) do
    vim.cmd('autocmd ' .. autocmd)
  end
  vim.cmd('augroup END')
end

function U.opt(scope, key, value)
  -- Setting `wo` or `bo` options ONLY sets the option for the very first open buffer.
  -- Conversely, `o` ONLY sets the option for the second open buffer onwards.
  -- This means, if a `wo` or `bo` option is set, we should set `o` as well.
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

return U
