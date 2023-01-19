-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/j-hui/fidget.nvim

local servers = {
  'bashls',
  'dockerls',
  'gopls',
  'jsonls',
  'pyright',
  'sqlls',
  'sumneko_lua',
  'svelte',
  'terraformls',
  'tsserver',
  'vimls'
}

local tools = {
  'autopep8',
  'debugpy',
  'delve',
  'flake8',
  'golangci-lint',
  'jsonlint',
  'luacheck',
  'markdownlint',
  'pylint',
  'rubocop',
  'shellcheck',
  'shfmt',
  'tflint'
}

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  update_in_insert = true,
  signs = false,
  severity_sort = true,
  virtual_text = {
    spacing = 1
  }
}
)

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP - ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  local vmap = function(keys, func, desc)
    if desc then
      desc = 'LSP - ' .. desc
    end

    vim.keymap.set('v', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('g]', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('g}', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Formatting keymaps
  nmap('<leader>f', vim.lsp.buf.format, '[F]ormat')
  vmap('<leader>f', vim.lsp.buf.format, '[F]ormat range')
end

require 'fidget'.setup {
  text = {
    spinner = 'dots',
    done = '✓'
  }
}

require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = servers
}
require('mason-tool-installer').setup {
  ensure_installed = tools
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
}

require('lspconfig').pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_new_config = function(new_config, root_dir)
    local pipfile_exists = require('lspconfig').util.search_ancestors(root_dir, function(path)
      local pipfile = require('lspconfig').util.path.join(path, 'Pipfile')
      if require('lspconfig').util.path.is_file(pipfile) then
        return true
      else
        return false
      end
    end)

    if pipfile_exists then
      new_config.cmd = { 'pipenv', 'run', 'pyright-langserver', '--stdio' }
    end
  end;
}

-- Setup solargraph separately, as mason ends up installing it to a central location,
-- which does not guarantee the same set of gems as a project. This makes it better to
-- install solargraph, rubocop, rubocop-rails, rubocop-performance, rubocop-rspec, standardrb
-- in the project.
require('lspconfig').solargraph.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
