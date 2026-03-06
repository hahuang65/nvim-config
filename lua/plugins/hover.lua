-- https://github.com/lewis6991/hover.nvim

return {
  "lewis6991/hover.nvim",
  keys = {
    { "K", function() require("hover").hover() end, desc = "hover.nvim" },
    { "<C-p>", function() require("hover").hover_switch("previous") end, desc = "hover.nvim (previous source)" },
    { "<C-n>", function() require("hover").hover_switch("next") end, desc = "hover.nvim (next source)" },
  },
  config = function()
    require("hover").setup({
      init = function()
        -- Require providers
        require("hover.providers.lsp")
        require("hover.providers.gh")
        require("hover.providers.gh_user")
        require("hover.providers.jira")
        require("hover.providers.dap")
        require("hover.providers.fold_preview")
        require("hover.providers.diagnostic")
        require("hover.providers.man")
        -- require("hover.providers.dictionary")
      end,
      preview_opts = {
        border = "single",
      },
      -- Whether the contents of a currently open hover window should be moved
      -- to a :h preview-window when pressing the hover keymap.
      preview_window = false,
      title = true,
    })
  end,
}
