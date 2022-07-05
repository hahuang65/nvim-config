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
  'TermOpen * lua if vim.startswith(vim.api.nvim_buf_get_name(0), "term://") then vim.cmd("startinsert") end', -- https://github.com/nvim-neotest/neotest/issues/2#issuecomment-1149532666
  'TermClose * call nvim_input("<CR>")' -- Closes the terminal once the shell is exited
})

augroup('format_on_save', {
  'BufWritePre * lua vim.lsp.buf.format()'
})

-- Winbar
vim.api.nvim_create_autocmd({"BufWinEnter", "BufFilePost" }, {
  callback = function()
    local winbar_filetype_exclude = {
      "help",
      "dashboard",
      "packer",
      "fugitive",
      "gitcommit",
      "NvimTree",
    }

    if vim.tbl_contains(winbar_filetype_exclude, vim.bo.filetype) then
      vim.opt_local.winbar = nil
      return
    end

    vim.opt_local.winbar = require('util').Filename()
  end,
})
