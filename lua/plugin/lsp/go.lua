-- brew install gopls / paru -S gopls

local common = require('plugin/lsp/common')

require'lspconfig'.gopls.setup {
  on_attach = common.on_attach,
  capabilities = common.capabilities
}
