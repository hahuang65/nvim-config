-- https://git.sr.ht/~whynothugo/lsp_lines.nvim

return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    require("lsp_lines").setup()

    -- https://github.com/folke/lazy.nvim/issues/620
    vim.diagnostic.config({ virtual_lines = false }, require("lazy.core.config").ns)
  end,
}
