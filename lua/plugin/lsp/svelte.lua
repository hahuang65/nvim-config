-- npm install -g svelte-language-server

local common = require('plugin/lsp/common')

require'lspconfig'.svelte.setup {
  on_attach = common.on_attach,
  capabilities = common.capabilities
}
