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

local wk = require("which-key")

-- Editing
map('n', 'gp', '`[v`]')
map('v', '>',  '>gv')
map('v', '<',  '<gv')

-- Make
wk.register({
  ['<leader>m']  = { name = "Make" },
  ['<leader>m:'] = { ':make! ', "Make (Prompt)" },
  ['<leader>ma'] = { ':make!<CR>', "Make" },
  ['<leader>mf'] = { ':lmake! %<CR>', "Make (File)" },
  ['<leader>mm'] = { ':lmake! %:<C-r>=line(".")<CR><CR>', "Make (Line)" }
})

-- Quickfix and Location List
wk.register({
  ['<leader>l'] = { ':lopen<CR>', "Location List" },
  ['<leader>q'] = { ':copen<CR>', "Quickfix List" }
})

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

-- vim-fugitive
-- https://github.com/tpope/vim-fugitive
wk.register({
  ['<leader>g']  = { name = "Git" },
  ['<leader>gg'] = { ':Git<CR>', "Fugitive" },
  ['<leader>gp'] = { ':Git publish<CR>', "Publish" },
  ['<leader>gA'] = { ':Git amend<CR>', "Amend" },
  ['<leader>gR'] = { ':Git retrunk<CR>', "Re-Trunk" },
  ['<leader>gS'] = { ':Git sync<CR>', "Sync" },
  ['<leader>gP'] = { ':Git publish<CR>', "Publish" },
  ['<leader>gR'] = { ':Git pr create --web --fill<CR>', "Create PR" }
})

-- vim-fugitive: conflicts
wk.register({
  ['<leader>g']  = { name = "Git" },
  ['<leader>g['] = { ':diffget //2 | :diffupdate<CR>', "Conflict Select (Left)" },
  ['<leader>g]'] = { ':diffget //3 | :diffupdate<CR>', "Conflict Select (Right)" }
})

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

wk.register({
  ['<leader><leader>'] = { [[<cmd>lua find_project_files()<CR>]], "Files" },
  ['<leader>?']        = { [[<cmd>Telescope live_grep<CR>]], "Grep (Project)" },
  ['<leader>/']        = { [[<cmd>Telescope current_buffer_fuzzy_find<CR>]], "Grep (Buffer)" },
  ['<leader>*']        = { [[<cmd>Telescope grep_string<CR>]], "Grep (String)" },
  ['<leader>b']        = { [[<cmd>Telescope buffers<CR>]], "Buffers" }
})

wk.register({
  ['<leader>g']  = { name = "Git" },
  ['<leader>gb'] = { [[<cmd>Telescope git_branches<CR>]], "Branch" },
  ['<leader>gc'] = { [[<cmd>Telescope git_bcommits<CR>]], "Commit (Buffer)" },
  ['<leader>gC'] = { [[<cmd>Telescope git_commits<CR>]], "Commit (Project)" }
})

wk.register({
  ['<leader>h']  = { name = "Help" },
  ['<leader>hc'] = { [[<cmd>Telescope commands<CR>]], "Commands" },
  ['<leader>hh'] = { [[<cmd>Telescope help_tags<CR>]], "Help Pages" },
  ['<leader>hk'] = { [[<cmd>Telescope keymaps<CR>]], "Keymaps" },
  ['<leader>hm'] = { [[<cmd>Telescope man_pages<CR>]], "Manpages" },
})

map('n', 't]', [[<cmd>Telescope current_buffer_tags<CR>]])
map('n', 't}', [[<cmd>Telescope tags<CR>]])

-- telescope-project
-- https://github.com/nvim-telescope/telescope-project.nvim
wk.register({
  ['<leader>p'] = { ":lua require'telescope'.extensions.project.project{}<CR>", "Projects" }
})

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
map('o', 'ih',         [[:<C-U>lua require"gitsigns.actions".select_hunk()<CR>]])
map('x', 'ih',         [[:<C-U>lua require"gitsigns.actions".select_hunk()<CR>]])
wk.register({
  ['<leader>g']  = { name = "Git" },
  ['<leader>gr'] = { [[<cmd>lua require"gitsigns".reset_hunk()<CR>]], "Reset Hunk" }
})

return {
  lsp_keymaps = lsp_keymaps
}
