-- npm install -g dockerfile-language-server-nodejs

local common = require('plugin/lsp/common')

require'lspconfig'.dockerls.setup {
  on_attach = common.on_attach,
  capabilities = common.capabilities
}
