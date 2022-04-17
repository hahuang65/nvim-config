-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/j-hui/fidget.nvim

-- Define diagnostic signs and highlighting colors
vim.fn.sign_define("LspDiagnosticsSignError", {
  text = "",
  texthl = "LspDiagnosticsDefaultError",
  numhl = "LspDiagnosticsDefaultError"
})

vim.fn.sign_define("LspDiagnosticsSignWarning", {
  text = "",
  texthl = "LspDiagnosticsDefaultWarning",
  numhl = "LspDiagnosticsDefaultWarning"
})

vim.fn.sign_define("LspDiagnosticsSignInformation", {
  text = "",
  texthl = "LspDiagnosticsDefaultInformation",
  numhl = "LspDiagnosticsDefaultInformation"
})

vim.fn.sign_define("LspDiagnosticsSignHint", {
  text = "",
  texthl = "LspDiagnosticsDefaultHint",
  numhl = "LspDiagnosticsDefaultHint"
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true,
    signs = false,
    virtual_text = {
      spacing = 1
    }
  }
)

require'fidget'.setup{
  text = {
    spinner = "dots",
    done = "✅"
  },
  timer = {
    fidget_decay = -1 -- Always show
  }
}

require'plugin/lsp/bash'
require'plugin/lsp/docker'
require'plugin/lsp/go'
require'plugin/lsp/lua'
require'plugin/lsp/python'
require'plugin/lsp/ruby'
require'plugin/lsp/rust'
require'plugin/lsp/terraform'
require'plugin/lsp/vim'
require'plugin/lsp/vue'
