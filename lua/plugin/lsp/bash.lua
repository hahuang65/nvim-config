-- npm install -g bash-language-server

local common = require('plugin/lsp/common')

require'lspconfig'.bashls.setup {
  on_attach = common.on_attach,
  capabilities = common.capabilities
}
