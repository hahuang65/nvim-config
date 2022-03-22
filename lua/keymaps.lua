local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function buf_map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, options)
end

local wk = require("which-key")

-- Editing
map('n', 'gp', '`[v`]')
map('v', '>',  '>gv')
map('v', '<',  '<gv')

wk.register({
  ['<leader>y']  = { '"+y', "Copy (to system clipboard)" },
}, { mode = 'v' })

wk.register({
  ['<leader>p']  = { '"+p', "Paste (from system clipboard)" },
})

-- Make
wk.register({
  ['<leader>m']  = { name = "Make" },
  ['<leader>m:'] = { ':make! ', "Make (Prompt)" },
  ['<leader>ma'] = { ':make!<CR>', "Make" },
  ['<leader>mf'] = { ':lmake! %<CR>', "Make (File)" },
  ['<leader>mm'] = { ':lmake! %:<C-r>=line(".")<CR><CR>', "Make (Line)" }
})

-- Test
wk.register({
  ['<leader>t']  = { name = "Test" },
  ['<leader>ta'] = { ':TestSuite<CR>', "Test All" },
  ['<leader>tf'] = { ':TestFile<CR>', "Test File" },
  ['<leader>tt'] = { ':TestNearest<CR>', "Test Nearest" }
})

-- Quickfix and Location List
wk.register({
  ['<leader>l'] = { ':lopen<CR>', "Location List" },
  ['<leader>q'] = { ':copen<CR>', "Quickfix List" },
  [']q']        = { ':cnext<CR>', "Next Quickfix Entry" },
  ['[q']        = { ':cprev<CR>', "Previous Quickfix Entry" },
  [']l']        = { ':lnext<CR>', "Next Location List Entry" },
  ['[l']        = { ':lprev<CR>', "Previous Location List Entry" }
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
  ['<leader>go'] = { ':Git repo view --web<CR>', "Open repository in browser" },
  ['<leader>gp'] = { ':Git publish<CR>', "Publish" },
  ['<leader>gr'] = { ':Git pr list --web<CR>', "List open PRs in browser" },
  ['<leader>gt'] = { ':Git retrunk<CR>', "Re-Trunk" },
  ['<leader>gs'] = { ':Git sync<CR>', "Sync" },
  ['<leader>gA'] = { ':Git amend<CR>', "Amend" },
  ['<leader>gR'] = { ':Git pr create --web --fill<CR>', "Create PR" },
  ['<leader>gO'] = { ':Git pr view --web<CR>', "Open PR in browser" }
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
  ['<leader>gc'] = { [[<cmd>Telescope git_bcommits<CR>]], "Commits (Buffer)" },
  ['<leader>gC'] = { [[<cmd>Telescope git_commits<CR>]], "Commits (Project)" }
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
  ['<leader>P'] = { ":lua require'telescope'.extensions.project.project{}<CR>", "Projects" }
})

-- LSP
-- https://github.com/neovim/nvim-lspconfig
-- These are in a function because they are bound when an LSP is attached.
-- lua/plugin/lsp.lua will load this function when the time is right
function lsp_keymaps()
  buf_map('n', 'gD',         '<Cmd>lua vim.lsp.buf.declaration()<CR>')
  buf_map('n', 'gd',         '<Cmd>lua vim.lsp.buf.definition()<CR>')
  buf_map('n', 'K',          '<Cmd>lua vim.lsp.buf.hover()<CR>')
  buf_map('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_map('n', '<leader>k',  '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  buf_map('n', '<leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_map('n', 'gr',         '<cmd>Telescope lsp_references<CR>')
  buf_map('n', '[d',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  buf_map('n', ']d',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  buf_map('n', '<leader>ll', '<cmd>Telescope lsp_document_diagnostics<CR>')
  buf_map('n', 'g]',         '<cmd>Telescope lsp_document_symbols<CR>')
  buf_map('n', 'g}',         '<cmd>Telescope lsp_workspace_symbols<CR>')
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

-- delve
-- https://github.com/sebdah/vim-delve
-- These are in a function so that they can be loaded ONLY for Go buffers.
function delve_keymaps()
  wk.register({
    ['<leader>d']  = { name = "Debug" },
    ['<leader>dd'] = { [[:DlvToggleBreakpoint<CR>]], "Toggle Breakpoint" },
    ['<leader>dD'] = { [[:DlvToggleTracepoint<CR>]], "Toggle Tracepoint" },
    ['<leader>dr'] = { [[:DlvDebug<CR>]],            "Delve Debug (main packages)" },
    ['<leader>dR'] = { [[:DlvDebug]],                "Delve Debug w/ flags" },
    ['<leader>dt'] = { [[:DlvTest<CR>]],             "Delve Test (non-main packages)" },
    ['<leader>dT'] = { [[:DlvTest]],                 "Delve Test w/flags" }
  }, { buffer = 0 })
end

-- Go
-- https://github.com/fatih/vim-go
-- These are in a function so that they can be loaded ONLY for Go buffers.
-- Remove these if https://github.com/vim-test/vim-test/issues/617 gets fixed
function go_keymaps()
  wk.register({
    ['<leader>ta'] = { ':GoTest!<CR>', "Test Package" },
    ['<leader>tf'] = { ':GoTest!<CR>', "Test Package" },
    ['<leader>tt'] = { ':GoTestFunc!<CR>)', "Test Nearest" }
  }, { buffer = 0 })
end

-- Orgmode
-- https://github.com/nvim-orgmode/orgmode
-- These are in a function so that they can be loaded ONLY for Org buffers.
function org_keymaps()
  wk.register({
    ['<leader>o']  = { name = "Orgmode" },
    ["<leader>o'"] = { '<Cmd>lua require("orgmode").action("org_mappings.edit_special")<CR>', "Edit Code Block" },
    ['<leader>o$'] = { '<Cmd>lua require("orgmode").action("org_mappings.archive")<CR>', "Archive Subtree" },
    ['<leader>o*'] = { '<Cmd>lua require("orgmode").action("org_mappings.toggle_heading")<CR>', "Toggle Headline" },
    ['<leader>o,'] = { '<Cmd>lua require("orgmode").action("org_mappings.set_priority")<CR>', "Set Priority" },
    ['<leader>oA'] = { '<Cmd>lua require("orgmode").action("agenda.toggle_archive_tag")<CR>', "Toggle Archive" },
    ['<leader>oJ'] = { '<Cmd>lua require("orgmode").action("org_mappings.move_subtree_down")<CR>', "Move Subtree Down" },
    ['<leader>oK'] = { '<Cmd>lua require("orgmode").action("org_mappings.move_subtree_up")<CR>', "Move Subtree Up" },
    ['<leader>oa'] = { '<Cmd>lua require("orgmode").action("agenda.prompt")<CR>', "Open Agenda" },
    ['<leader>oc'] = { '<Cmd>lua require("orgmode").action("capture.prompt")<CR>', "Capture" },
    ['<leader>oe'] = { '<Cmd>lua require("orgmode").action("org_mappings.export")<CR>', "Export" },
    ['<leader>ok'] = { '<Cmd>lua require("orgmode").action("capture.kill")<CR>', "Kill Capture" },
    ['<leader>oo'] = { '<Cmd>lua require("orgmode").action("org_mappings.open_at_point")<CR>', "Follow Link/Date" },
    ['<leader>or'] = { '<Cmd>lua require("orgmode").action("capture.refile_headline_to_destination")<CR>', "Refile" },
    ['<leader>ot'] = { '<Cmd>lua require("orgmode").action("org_mappings.set_tags")<CR>', "Tag" },
    ['<leader>oi'] = { name = "Insert" },
    ['<leader>oi!'] = { '<Cmd>lua require("orgmode").action("org_mappings.org_timestamp", "true")<CR>', "Timestamp (Inactive)" },
    ['<leader>oi.'] = { '<Cmd>lua require("orgmode").action("org_mappings.org_timestamp")<CR>', "Timestamp" },
    ['<leader>oiT'] = { '<Cmd>lua require("orgmode").action("org_mappings.insert_todo_heading")<CR>', "TODO (Immediate)" },
    ['<leader>oid'] = { '<Cmd>lua require("orgmode").action("org_mappings.org_deadline")<CR>', "Deadline" },
    ['<leader>oih'] = { '<Cmd>lua require("orgmode").action("org_mappings.insert_heading_respect_content")<CR>', "Heading" },
    ['<leader>ois'] = { '<Cmd>lua require("orgmode").action("org_mappings.org_schedule")<CR>', "Schedule" },
    ['<leader>oit'] = { '<Cmd>lua require("orgmode").action("org_mappings.insert_todo_heading_respect_content")<CR>', "TODO" },
    ['<leader>ox'] = { name = "Clock" },
    ['<leader>oxe'] = { '<Cmd>lua require("orgmode").action("agenda.set_effort")<CR>', "Set Effort" },
    ['<leader>oxi'] = { '<Cmd>lua require("orgmode").action("agenda.clock_in")<CR>', "Clock In" },
    ['<leader>oxj'] = { '<Cmd>lua require("orgmode").action("clock.org_clock_goto")<CR>', "Goto Clock" },
    ['<leader>oxo'] = { '<Cmd>lua require("orgmode").action("agenda.clock_out")<CR>', "Clock Out" },
    ['<leader>oxq'] = { '<Cmd>lua require("orgmode").action("agenda.clock_cancel")<CR>', "Cancel Clock" },
  }, { buffer = 0 })
end

return {
  lsp_keymaps = lsp_keymaps,
  delve_keymaps = delve_keymaps,
  go_keymaps = go_keymaps,
  org_keymaps = org_keymaps
}
