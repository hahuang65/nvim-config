-- https://git.sr.ht/~whynothugo/lsp_lines.nvim

return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  lazy = true,
  event = "VeryLazy", -- Using LSPAttach doesn't help on files where there's only a linter and no language server. DiagnosticChanged loads properly, but the plugin doesn't show anything until a save happens
  config = function()
    require("lsp_lines").setup()

    -- https://github.com/folke/lazy.nvim/issues/620
    vim.diagnostic.config({ virtual_lines = false }, require("lazy.core.config").ns)
  end,
}
