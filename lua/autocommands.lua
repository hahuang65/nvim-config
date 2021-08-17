local function augroup(name, autocmds)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')
  for _, autocmd in ipairs(autocmds) do
    vim.cmd('autocmd ' .. autocmd)
  end
  vim.cmd('augroup END')
end

-- Auto Reload
augroup('autoreload', {
  'FocusGained, BufEnter * silent! checktime'
})

-- Active Window
augroup('active_window', {
  'WinEnter,BufEnter * if &buftype != "terminal" | setlocal cursorline cursorcolumn | endif',
  'WinLeave,BufLeave * setlocal nocursorline nocursorcolumn'
})

-- Highlight text on yank
augroup('yank_highlight', {
  'TextYankPost * silent! lua vim.highlight.on_yank()'
})

-- Auto Source Config Files
augroup('nvim_config', {
  'BufWritePost $MYVIMRC nested source $MYVIMRC',
  'BufWritePost */nvim/**/*.lua PackerCompile'
})

-- Terminal
augroup('terminal', {
  'TermOpen * setlocal nonumber norelativenumber nocursorline nocursorcolumn signcolumn=no',
  'TermOpen * nnoremap <buffer> <C-c> i<C-c>',
  'TermOpen * startinsert',
  'TermClose * call nvim_input("<CR>")' -- Closes the terminal once the shell is exited
})

-- Rspec
augroup('rspec', {
  'BufNewFile,BufRead *_spec.rb,*_shared_examples.rb,*_shared_context.rb compiler rspec | set makeprg=bin/rspec'
})