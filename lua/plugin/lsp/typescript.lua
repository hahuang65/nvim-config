-- npm install -g typescript-language-server

local common = require('plugin/lsp/common')

require'lspconfig'.tsserver.setup {
  on_attach = common.on_attach,
  capabilities = common.capabilities
}
