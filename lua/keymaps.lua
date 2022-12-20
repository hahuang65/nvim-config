-- Visual Mode
vim.keymap.set('v', '>', '>gv', { desc = 'Re-highlight after indenting' })
vim.keymap.set('v', '<', '<gv', { desc = 'Re-highlight after indenting' })

-- Copy/Paste
vim.keymap.set({ 'n', 'v' },      '<leader>y', '"+y',    { desc = 'Copy to system clipboard' })
vim.keymap.set({ 'n', 'v' },      '<leader>Y', '"+Y',    { desc = 'Copy line to system clipboard' })
vim.keymap.set({ 'n', 'v' },      '<leader>p', '"+p',    { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'v' },      '<leader>P', '"+P',    { desc = 'Paste (above) from system clipboard' })
vim.keymap.set('x', '<leader>cp', require('util').paste, { desc = '[C]reate [P]aste in paste.sr.ht' })

-- Quickfix
vim.keymap.set('n', '<leader>q', require('util').toggle_quickfix, { desc = 'Toggle [q]uickfix list' })
vim.keymap.set('n', ']q',        ':cnext<CR>',                    { desc = 'Next quickfix entry' })
vim.keymap.set('n', '[q',        ':cprev<CR>',                    { desc = 'Previous quickfix entry' })

-- Terminal
vim.keymap.set('t', '<Esc>',  '<C-\\><C-n>',       { desc = 'Go to normal mode' })
vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h', { desc = 'Switch to window left' })
vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j', { desc = 'Switch to window below' })
vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k', { desc = 'Switch to window above' })
vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l', { desc = 'Switch to window right' })

vim.keymap.set('n', '<M-[>', ':Terminal Console<CR>',             { desc = 'Open console terminal' })
vim.keymap.set('t', '<M-[>', '<C-\\><C-n>:Terminal Console<CR>',  { desc = 'Open console terminal' })
vim.keymap.set('n', '<M-{>', ':Vterminal Console<CR>',            { desc = 'Open console terminal (vertical)' })
vim.keymap.set('t', '<M-{>', '<C-\\><C-n>:Vterminal Console<CR>', { desc = 'Open console terminal (vertical)' })

vim.keymap.set('n', '<M-]>', ':Terminal Server<CR>',             { desc = 'Open server terminal' })
vim.keymap.set('t', '<M-]>', '<C-\\><C-n>:Terminal Server<CR>',  { desc = 'Open server terminal' })
vim.keymap.set('n', '<M-}>', ':Vterminal Server<CR>',            { desc = 'Open server terminal (vertical)' })
vim.keymap.set('t', '<M-}>', '<C-\\><C-n>:Vterminal Server<CR>', { desc = 'Open server terminal (vertical)' })

vim.keymap.set('n', '<M-`>', ':Terminal Terminal<CR>',             { desc = 'Open terminal' })
vim.keymap.set('t', '<M-`>', '<C-\\><C-n>:Terminal Terminal<CR>',  { desc = 'Open terminal (vertical)' })
vim.keymap.set('n', '<M-~>', ':Vterminal Terminal<CR>',            { desc = 'Open terminal (vertical)' })
vim.keymap.set('t', '<M-~>', '<C-\\><C-n>:Vterminal Terminal<CR>', { desc = 'Open terminal (vertical)' })

-- Project quick-access
vim.keymap.set('n', '<leader>ed', require('finders').dotfiles, { desc = '[E]dit [D]otfiles' })
vim.keymap.set('n', '<leader>ep', require('finders').projects, { desc = '[E]dit [P]rojects' })
vim.keymap.set('n', '<leader>ev', require('finders').config,   { desc = '[E]dit Neo[v]im Config' })

-- Diagnostics
vim.keymap.set('n', '[d',        vim.diagnostic.goto_prev,  { desc = 'Previous Diagnostic', buffer = true })
vim.keymap.set('n', ']d',        vim.diagnostic.goto_next,  { desc = 'Next Diagnostic', buffer = true })
vim.keymap.set('n', '<leader>D', vim.diagnostic.open_float, { desc = 'Open Diagnostic in Float', buffer = true })
