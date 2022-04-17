-- npm install -g vls

local common = require('plugin/lsp/common')

require'lspconfig'.vuels.setup {
  on_attach = common.on_attach,
  capabilities = common.capabilities
}
