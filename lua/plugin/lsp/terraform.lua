-- brew install hashicorp/tap/terraform-ls / paru -S terraform-ls

local common = require('plugin/lsp/common')

require'lspconfig'.terraformls.setup {
  on_attach = common.on_attach,
  capabilities = common.capabilities
}
