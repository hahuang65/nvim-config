-- paru -S rust-analyzer / brew install rust-analyzer

local common = require('plugin/lsp/common')

require'lspconfig'.rust_analyzer.setup {
  on_attach = common.on_attach,
  capabilities = common.capabilities
}
