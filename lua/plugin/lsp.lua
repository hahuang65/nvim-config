-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/j-hui/fidget.nvim

-- Enumerate the LSP servers desired
-- npm install -g bash-language-server
-- npm install -g dockerfile-language-server-nodejs
-- brew install gopls / paru -S gopls
-- brew install hashicorp/tap/terraform-ls / paru -S terraform-ls
-- pip install  pyright (run `asdf reshim python` to get the executable accessible)
-- paru -S rust-analyzer / brew install rust-analyzer
-- npm install -g typescript-language-server
-- npm install -g vls
-- npm install -g vim-language-server
local servers = {
  'bashls',
  'dockerls',
  'gopls',
  'pyright',
  'rust_analyzer',
  'solargraph',
  'terraformls',
  'tsserver',
  'vimls',
  'vuels'
}

-- Define diagnostic signs and highlighting colors
vim.fn.sign_define("LspDiagnosticsSignError", {
  text = "",
  texthl = "LspDiagnosticsDefaultError",
  numhl = "LspDiagnosticsDefaultError"
})
vim.fn.sign_define("LspDiagnosticsSignWarning", {
  text = "",
  texthl = "LspDiagnosticsDefaultWarning",
  numhl = "LspDiagnosticsDefaultWarning"
})
vim.fn.sign_define("LspDiagnosticsSignInformation", {
  text = "",
  texthl = "LspDiagnosticsDefaultInformation",
  numhl = "LspDiagnosticsDefaultInformation"
})
vim.fn.sign_define("LspDiagnosticsSignHint", {
  text = "",
  texthl = "LspDiagnosticsDefaultHint",
  numhl = "LspDiagnosticsDefaultHint"
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true,
    signs = false,
    virtual_text = {
      spacing = 1
    }
  }
)
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  require'keymaps'.lsp_keymaps()

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

  -- lsp_signature
  -- https://github.com/ray-x/lsp_signature.nvim
  require "lsp_signature".on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
    border = "single"
    }
  })
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
sumneko_root_path = vim.fn.stdpath('cache')..'/lua-language-server'
sumneko_binary = sumneko_root_path.."/bin/lua-language-server"

local function sumneko_exists()
  local f = io.open(sumneko_binary, "r")
  if f ~= nil then io.close(f) return true else return false end
end

if sumneko_exists() == false then
  print("Sumneko not installed, please install using install_sumneko_lua.sh.")
end

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

require'fidget'.setup{
  text = {
    spinner = "dots",
    done = "✅"
  },
  timer = {
    fidget_decay = -1 -- Always show
  }
}
