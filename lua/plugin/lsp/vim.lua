-- npm install -g vim-language-server

local common = require('plugin/lsp/common')

require'lspconfig'.vimls.setup {
  on_attach = common.on_attach,
  capabilities = common.capabilities
}
