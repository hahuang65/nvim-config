local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function buf_map(bufnr, mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

-- Editing
map('n', 'gp', '`[v`]')
map('v', '>',  '>gv')
map('v', '<',  '<gv')

-- Make
map('n', '<leader>m:', ':make! ')
map('n', '<leader>ma', ':make!<CR>')
map('n', '<leader>mf', ':lmake! %<CR>')
map('n', '<leader>mm', ':lmake! %:<C-r>=line(".")<CR><CR>')

-- Quickfix and Location List
map('n', '<leader>l',  ':lopen<CR>')
map('n', '<leader>q',  ':copen<CR>')

-- Terminal: navigation
map('t', '<Esc>',  '<C-\\><C-n>')
map('t', '<C-w>h', '<C-\\><C-n><C-w>h')
map('t', '<C-w>j', '<C-\\><C-n><C-w>j')
map('t', '<C-w>k', '<C-\\><C-n><C-w>k')
map('t', '<C-w>l', '<C-\\><C-n><C-w>l')

-- Terminal: toggles
map('n', '<M-[>', ':Terminal Console<CR>')
map('t', '<M-[>', '<C-\\><C-n>:Terminal Console<CR>')
map('n', '<M-{>', ':Vterminal Console<CR>')
map('t', '<M-{>', '<C-\\><C-n>:Vterminal Console<CR>')

map('n', '<M-]>', ':Terminal Server<CR>')
map('t', '<M-]>', '<C-\\><C-n>:Terminal Server<CR>')
map('n', '<M-}>', ':Vterminal Server<CR>')
map('t', '<M-}>', '<C-\\><C-n>:Vterminal Server<CR>')

map('n', '<M-`>', ':Terminal Terminal<CR>')
map('t', '<M-`>', '<C-\\><C-n>:Terminal Terminal<CR>')
map('n', '<M-~>', ':Vterminal Terminal<CR>')
map('t', '<M-~>', '<C-\\><C-n>:Vterminal Terminal<CR>')

-- nvim-compe
-- https://github.com/hrsh7th/nvim-compe
map('i', '<C-Space>', [[compe#complete()]],              { expr = true })
map('i', '<CR>',      [[compe#confirm('<CR>')]],         { expr = true })
map('i', '<C-e>',     [[compe#close('<C-e>')]],          { expr = true })
map('i', '<C-f>',     [[compe#scroll({ 'delta': +4 })]], { expr = true })
map('i', '<C-d>',     [[compe#scroll({ 'delta': -4 })]], { expr = true })

-- vim-fugitive
-- https://github.com/tpope/vim-fugitive
map('n', '<leader>gA',  ':Git amend<CR>')
map('n', '<leader>gg',  ':Git<CR>')
map('n', '<leader>gP',  ':Git publish<CR>')
map('n', '<leader>gR',  ':Git retrunk<CR>')
map('n', '<leader>gS',  ':Git sync<CR>')
map('n', '<leader>pr',  ':Git pr create --web --fill<CR>')

-- vim-fugitive: conflicts
map('n', '<leader>[', ':diffget //2 | :diffupdate<CR>')
map('n', '<leader>]', ':diffget //3 | :diffupdate<CR>')

-- nvim-tree
-- https://github.com/kyazdani42/nvim-tree.lua
map('n', '<C-\\>', ':NvimTreeToggle<CR>')

-- telescope
-- https://github.com/nvim-telescope/telescope.nvim
-- The 2 `g` bindings for buffer tags and tags should be overridden when LSP loads
-- This just means that tags will be used for files without LSP, and LSP symbols will be used for files with LSP.
map('n', 'g]',  [[<cmd>Telescope current_buffer_tags<CR>]])
map('n', 'g}',  [[<cmd>Telescope tags<CR>]])
map('n', 'g\\', [[<cmd>Telescope treesitter<CR>]])

map('n', '<leader><leader>', [[<cmd>lua find_project_files()<CR>]])
map('n', '<leader>ff',       [[<cmd>Telescope find_files<CR>]])

map('n', '<leader>?',  [[<cmd>Telescope live_grep<CR>]])
map('n', '<leader>/',  [[<cmd>Telescope current_buffer_fuzzy_find<CR>]])
map('n', '<leader>*',  [[<cmd>Telescope grep_string<CR>]])
map('n', '<leader>b',  [[<cmd>Telescope buffers<CR>]])

map('n', '<leader>gb', [[<cmd>Telescope git_branches<CR>]])
map('n', '<leader>gc', [[<cmd>Telescope git_bcommits<CR>]])
map('n', '<leader>gC', [[<cmd>Telescope git_commits<CR>]])

map('n', '<leader>hc', [[<cmd>Telescope commands<CR>]])
map('n', '<leader>hh', [[<cmd>Telescope help_tags<CR>]])
map('n', '<leader>hk', [[<cmd>Telescope keymaps<CR>]])
map('n', '<leader>hm', [[<cmd>Telescope man_pages<CR>]])

map('n', 't]', [[<cmd>Telescope current_buffer_tags<CR>]])
map('n', 't}', [[<cmd>Telescope tags<CR>]])

-- telescope-project
-- https://github.com/nvim-telescope/telescope-project.nvim
map('n', '<leader>pp', ":lua require'telescope'.extensions.project.project{}<CR>")

-- LSP
-- https://github.com/neovim/nvim-lspconfig
-- These are in a function because they are bound when an LSP is attached.
-- lua/plugin/lsp.lua will load this function when the time is right
function lsp_keymaps(bufnr)
  buf_map(bufnr, 'n', 'gD',         '<Cmd>lua vim.lsp.buf.declaration()<CR>')
  buf_map(bufnr, 'n', 'gd',         '<Cmd>lua vim.lsp.buf.definition()<CR>')
  buf_map(bufnr, 'n', 'K',          '<Cmd>lua vim.lsp.buf.hover()<CR>')
  buf_map(bufnr, 'n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_map(bufnr, 'n', '<leader>k',  '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  buf_map(bufnr, 'n', '<leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  buf_map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_map(bufnr, 'n', 'gr',         '<cmd>Telescope lsp_references<CR>')
  buf_map(bufnr, 'n', '[d',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  buf_map(bufnr, 'n', ']d',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  buf_map(bufnr, 'n', '<leader>ll', '<cmd>Telescope lsp_document_diagnostics<CR>')
  buf_map(bufnr, 'n', 'g]',         '<cmd>Telescope lsp_document_symbols<CR>')
  buf_map(bufnr, 'n', 'g}',         '<cmd>Telescope lsp_workspace_symbols<CR>')
end

-- gitsigns
-- https://github.com/lewis6991/gitsigns.nvim
map('n', ']h',         [[&diff ? ']h' : '<cmd>lua require"gitsigns".next_hunk()<CR>']], { expr = true })
map('n', '[h',         [[&diff ? '[h' : '<cmd>lua require"gitsigns".prev_hunk()<CR>']], { expr = true })
map('n', '<leader>gr', [[<cmd>lua require"gitsigns".reset_hunk()<CR>]])
map('o', 'ih',         [[:<C-U>lua require"gitsigns.actions".select_hunk()<CR>]])
map('x', 'ih',         [[:<C-U>lua require"gitsigns.actions".select_hunk()<CR>]])

return {
  lsp_keymaps = lsp_keymaps
}
