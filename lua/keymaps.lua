local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

local function buf_map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true, buffer = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

local wk = require("which-key")

-- Editing
wk.register({
  ['gp'] = { '`[v`]', 'Select Previous Edit' }
})
map('v', '>',  '>gv')
map('v', '<',  '<gv')

wk.register({
  ['<leader>y']  = { '"+y', "Copy (to system clipboard)" }
}, { mode = 'v' })

wk.register({
  ['<leader>p']  = { '"+p', "Paste (from system clipboard)" }
})

wk.register({
  ['<leader>P']  = { ":lua Paste()<CR>", "Paste (to paste.sr.ht)" }
}, { mode = 'x' })

-- Make
wk.register({
  ['<leader>m']  = { name = "Make" },
  ['<leader>m:'] = { ':make! ',                           "Make (Prompt)" },
  ['<leader>ma'] = { ':make!<CR>',                        "Make" },
  ['<leader>mf'] = { ':lmake! %<CR>',                     "Make (File)" },
  ['<leader>mm'] = { ':lmake! %:<C-r>=line(".")<CR><CR>', "Make (Line)" }
})

-- Test
wk.register({
  ['<leader>t']  = { name = "Test" },
  ['<leader>ta'] = { ':TestSuite<CR>',   "Test All" },
  ['<leader>tf'] = { ':TestFile<CR>',    "Test File" },
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

wk.register({
  -- vim-fugitive
  -- https://github.com/tpope/vim-fugitive
  ['<leader>g']  = { name = "Git" },
  ['<leader>gg'] = { ':Git<CR>',                        "Fugitive" },
  ['<leader>go'] = { ':Git repo view --web<CR>',        "Open repository in browser" },
  ['<leader>gp'] = { ':Git publish<CR>',                "Publish" },
  ['<leader>gt'] = { ':Git retrunk<CR>',                "Rebase Against Trunk" },
  ['<leader>gs'] = { ':Git sync<CR>',                   "Sync" },
  ['<leader>gA'] = { ':help fugitive_c<CR>',            "Amend" },
  ['<leader>gN'] = { ':Git new',                        "New Branch" },
  ['<leader>gO'] = { ':Git pr view --web<CR>',          "Open PR in browser" },
  ['<leader>gP'] = { ':Git pr list --web<CR>',          "List open PRs in browser" },
  ['<leader>gR'] = { ':Git pr create --web --fill<CR>', "Create PR" },
  ['<leader>gS'] = { ':Git shove<CR>',                  "Shove" },
  ['<leader>g['] = { ':diffget //2 | :diffupdate<CR>',  "Conflict Select (Left)" },
  ['<leader>g]'] = { ':diffget //3 | :diffupdate<CR>',  "Conflict Select (Right)" },

  -- gitsigns
  -- https://github.com/lewis6991/gitsigns.nvim
  [']h']         = { [[&diff ? ']h' : '<cmd>lua require"gitsigns".next_hunk()<CR>']], "Next Git Hunk",     expr = true },
  ['[h']         = { [[&diff ? '[h' : '<cmd>lua require"gitsigns".prev_hunk()<CR>']], "Previous Git Hunk", expr = true },
  ['<leader>gr'] = { [[<cmd>lua require"gitsigns".reset_hunk()<CR>]],                 "Reset Hunk" },
  ['<leader>g?'] = { [[<cmd>lua require"gitsigns".preview_hunk()<CR>]],               "Preview Hunk" },

  ['<leader>gb'] = { [[<cmd>Telescope git_branches<CR>]], "Branch" },
  ['<leader>gc'] = { [[<cmd>Telescope git_bcommits<CR>]], "Commits (Buffer)" },
  ['<leader>gC'] = { [[<cmd>Telescope git_commits<CR>]],  "Commits (Project)" }
})

wk.register({
  ['ih'] = { [[:<C-U>lua require"gitsigns.actions".select_hunk()<CR>]], "Select Git Hunk" }
}, { mode = 'o' })

wk.register({
  ['ih'] = { [[:<C-U>lua require"gitsigns.actions".select_hunk()<CR>]], "Select Git Hunk" }
}, { mode = 'x' })

-- nvim-tree
-- https://github.com/kyazdani42/nvim-tree.lua
map('n', '<C-\\>', ':NvimTreeToggle<CR>')

-- telescope
-- https://github.com/nvim-telescope/telescope.nvim
-- The 2 `g` bindings for buffer tags and tags should be overridden when LSP loads
-- This just means that tags will be used for files without LSP, and LSP symbols will be used for files with LSP.
wk.register({
  ['g]'] =  { [[<cmd>Telescope current_buffer_tags<CR>]], "Tags (Buffer)" },
  ['g}'] =  { [[<cmd>Telescope tags<CR>]],                "Tags (Project)" },
  ['g\\'] = { [[<cmd>Telescope treesitter<CR>]],          "Treesitter Symbols" }
})

-- These can be used to invoke ctags in an LSP-enabled project
wk.register({
  ['t]'] =  { [[<cmd>Telescope current_buffer_tags<CR>]], "Tags (Buffer)" },
  ['t}'] =  { [[<cmd>Telescope tags<CR>]],                "Tags (Project)" },
})

wk.register({
  ['<leader><leader>'] = { [[<cmd>lua find_project_files()<CR>]],            "Files" },
  ['<leader>?']        = { [[<cmd>Telescope live_grep<CR>]],                 "Grep (Project)" },
  ['<leader>/']        = { [[<cmd>Telescope current_buffer_fuzzy_find<CR>]], "Grep (Buffer)" },
  ['<leader>*']        = { [[<cmd>Telescope grep_string<CR>]],               "Grep (String)" },
  ['<leader>b']        = { [[<cmd>Telescope buffers<CR>]],                   "Buffers" }
})

-- Treesitter Objects
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
wk.register({
  ['vaf'] =        { 'function' },
  ['vif'] =        { 'function' },
  ['vac'] =        { 'class' },
  ['vic'] =        { 'class' },
  [']]'] =         { 'Next class start' },
  [']['] =         { 'Next class end' },
  ['[['] =         { 'Previous class start' },
  ['[]'] =         { 'Previous class end' },
  ['<leader>c'] =  { Name = 'Code' },
  ['<leader>cc'] = { 'Peek at class' },
  ['<leader>cf'] = { 'Peek at function' },
  ['cp'] =         { 'Swap parameter forward' },
  ['cP'] =         { 'Swap parameter backward' },
})

wk.register({
  ['<leader>h']  = { name = "Help" },
  ['<leader>hc'] = { [[<cmd>Telescope commands<CR>]],  "Commands" },
  ['<leader>hh'] = { [[<cmd>Telescope help_tags<CR>]], "Help Pages" },
  ['<leader>hk'] = { [[<cmd>Telescope keymaps<CR>]],   "Keymaps" },
  ['<leader>hm'] = { [[<cmd>Telescope man_pages<CR>]], "Manpages" },
})

-- Shortcuts to edit special projects/files
wk.register({
  ['<leader>e']  = { name = "Edit" },
  ['<leader>ed'] = { [[<cmd>lua find_dotfiles()<CR>]], "Dotfiles" },
  ['<leader>ev'] = { [[<cmd>lua find_nvim_config()<CR>]],     "Neovim Config" }
})

-- telescope-project
-- https://github.com/nvim-telescope/telescope-project.nvim
wk.register({
  ['<leader>ep'] = { ":lua require'telescope'.extensions.project.project{}<CR>", "Projects" }
})

-- LuaSnip
-- https://github.com/L3MON4D3/LuaSnip
local ls = require"luasnip"

map({'i', 's'}, '<C-k>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end)

map({'i', 's'}, '<C-j>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end)

map({'i', 's'}, '<C-l>', function()
  if ls.choice_active then
    ls.change_choice(1)
  end
end)

wk.register({
  ['<leader>s'] = { name = "Snippets" },
  ['<leader>sr'] = { [[<Cmd>source $HOME/.dotfiles/nvim/lua/plugin/snippets.lua<CR>]], "Reload Snippets" },
  ['<leader>se'] = { [[<Cmd>lua EditSnippetsCurrentFiletype()<CR>]],                   "Edit Snippets (Current Filetype)" },
  ['<leader>sE'] = { [[<Cmd>lua EditSnippetsPromptFiletype()<CR>]],                    "Edit Snippets (Prompt Filetype)" },
})

-- comment.nvim
-- https://github.com/numToStr/Comment.nvim
wk.register({
 ['gb'] =  { name = "Comment (Blockwise)" },
 ['gbc'] = { "Toggle Block" }
})

wk.register({
 ['gc'] =  { name = "Comment (Linewise)" },
 ['gcc'] = { "Toggle Line" },
 ['gco'] = { "Add comment below" },
 ['gcA'] = { "Add comment above" },
 ['gcO'] = { "Add comment above" },

})
-- LSP
-- https://github.com/neovim/nvim-lspconfig
-- These are in a function because they are bound when an LSP is attached.
-- lua/plugin/lsp.lua will load this function when the time is right
local function lsp_keymaps()
  wk.register({
    ['gD'] =         { '<Cmd>lua vim.lsp.buf.declaration()<CR>',      "Go to Declaration" },
    ['gd'] =         { '<Cmd>lua vim.lsp.buf.definition()<CR>',       "Go to Definition" },
    ['gi'] =         { '<Cmd>lua vim.lsp.buf.implementation()<CR>',   "Go to Implementation" },
    ['gr'] =         { '<Cmd>Telescope lsp_references<CR>',           "Show Other References" },
    ['gt'] =         { '<Cmd>lua vim.lsp.buf.type_definition()<CR>',  "Go to Type Definition" },
    ['g]'] =         { '<Cmd>Telescope lsp_document_symbols<CR>',     "LSP Symbols (Buffer)" },
    ['g}'] =         { '<Cmd>Telescope lsp_workspace_symbols<CR>',    "LSP Symbols (Project)" },
    ['K'] =          { '<Cmd>lua vim.lsp.buf.hover()<CR>',            "Hover" },
    ['[d'] =         { '<Cmd>lua vim.diagnostic.goto_prev()<CR>',     "Previous Diagnostic" },
    [']d'] =         { '<Cmd>lua vim.diagnostic.goto_next()<CR>',     "Next Diagnostic" },
    ['<leader>k'] =  { '<Cmd>lua vim.lsp.buf.signature_help()<CR>',   "Show Signature Help" },
    ['<leader>ll'] = { '<Cmd>Telescope lsp_document_diagnostics<CR>', "List Diagnostics" },
    ['<leader>R'] =  { '<Cmd>lua vim.lsp.buf.rename()<CR>',           "Rename" }
  }, { buffer = 0 })
end

-- delve
-- https://github.com/sebdah/vim-delve
-- These are in a function so that they can be loaded ONLY for Go buffers.
local function delve_keymaps()
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
local function go_keymaps()
  wk.register({
    ['<leader>ta'] = { ':GoTest!<CR>',      "Test Go Package" },
    ['<leader>tf'] = { ':GoTest!<CR>',      "Test Go Package" },
    ['<leader>tt'] = { ':GoTestFunc!<CR>)', "Test Go Function" }
  }, { buffer = 0 })
end

-- Orgmode
-- https://github.com/nvim-orgmode/orgmode
-- These are in a function so that they can be loaded ONLY for Org buffers.
-- Weirdly, which-key is UNABLE to just provide labels without un-binding the functions...
-- So for now, we have to keep the mappings a bit more verbose by calling the functions specifically.
local function org_keymaps()
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
