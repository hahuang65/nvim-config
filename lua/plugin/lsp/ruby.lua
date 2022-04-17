-- gem install solargraph

local common = require('plugin/lsp/common')

require'lspconfig'.solargraph.setup {
  on_attach = common.on_attach,
  capabilities = common.capabilities
}
