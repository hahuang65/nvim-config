-- https://github.com/neovim/nvim-lspconfig

-- Enumerate the LSP servers desired
-- npm install -g bash-language-server
-- npm install -g dockerfile-language-server-nodejs
-- brew install hashicorp/tap/terraform-ls / paru -S terraform-ls
-- pip install 'python-language-server[all]' (run `asdf reshim python` to get the executable accessible)
-- paru -S rust-analyzer / brew install rust-analyzer
-- npm install -g typescript-language-server
-- npm install -g vls
-- npm install -g vim-language-server
local servers = {
  'bashls',
  'dockerls',
  'pylsp',
  'rust_analyzer',
  'solargraph',
  'terraformls',
  'tsserver',
  'vimls',
  'vuels'
}

-- Define diagnostic signs and highlighting colors
vim.fn.sign_define("LspDiagnosticsSignError", {
  -- text = "",
  text = "",
  texthl = "LspDiagnosticsDefaultError",
  numhl = "LspDiagnosticsDefaultError"
})
vim.fn.sign_define("LspDiagnosticsSignWarning", {
  -- text = "",
  text = "",
  texthl = "LspDiagnosticsDefaultWarning",
  numhl = "LspDiagnosticsDefaultWarning"
})
vim.fn.sign_define("LspDiagnosticsSignInformation", {
  -- text = "",
  text = "",
  texthl = "LspDiagnosticsDefaultInformation",
  numhl = "LspDiagnosticsDefaultInformation"
})
vim.fn.sign_define("LspDiagnosticsSignHint", {
  -- text = "",
  text = "",
  texthl = "LspDiagnosticsDefaultHint",
  numhl = "LspDiagnosticsDefaultHint"
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>ll', '<cmd>Telescope lsp_document_diagnostics<CR>', opts)
  buf_set_keymap('n', 'g]', '<cmd>Telescope lsp_document_symbols<CR>', opts)
  buf_set_keymap('n', 'g}', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead term=underline cterm=bold gui=underline
      hi LspReferenceText term=underline cterm=bold gui=underline
      hi LspReferenceWrite term=underline cterm=bold gui=underline
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local nvim_lsp = require('lspconfig')

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach, capabilities = capabilities }
end

-- Setup sumneko_lua separately since it has special settings
-- https://github.com/sumneko/lua-language-server
-- Install with `./install_sumneko_lua.sh`
local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

local sumneko_root_path = vim.fn.stdpath('cache')..'/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      }
    }
  }
}
