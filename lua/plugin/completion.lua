-- https://github.com/nvim-lua/completion-nvim
local nvim_lsp = require('lspconfig')

-- Use a loop to conveniently both setup completion based on LSP servers
for _, lsp in ipairs(require'lsp_servers') do
  nvim_lsp[lsp].setup { on_attach = require'completion'.on_attach }
end
