-- https://github.com/emmanueltouzery/apidocs.nvim
-- Need to install https://github.com/rkd77/elinks

return {
  "emmanueltouzery/apidocs.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- or, 'folke/snacks.nvim'
  },
  cmd = { "ApidocsSearch", "ApidocsInstall", "ApidocsOpen", "ApidocsSelect", "ApidocsUninstall" },
  config = function()
    require("apidocs").setup({ picker = "telescope" })
    require("apidocs").ensure_install({
      -- May need to go to ~/.local/share/nvim/apidocs-data
      -- and run `find . -maxdepth 1 -name '*.html' -print0 | xargs -0 -P 8 -I param sh -c "elinks -config-dir .. -dump 'param' > 'param'.md && rm 'param'"`
      -- in each sub-directory
      "bash",
      "docker",
      "duckdb",
      "fastapi",
      "gnu_make",
      "go",
      "html",
      "jq",
      "love",
      "lua~5.1",
      "man",
      "markdown",
      "nix",
      "pandas~2",
      "postgresql~18",
      "python~3.14",
      "redis",
      "ruby~3.4",
      "rails~8.0",
      "vue~3",
    })
  end,
  keys = {
    { "<leader>D", "<cmd>ApidocsOpen<cr>", desc = "Search Docs" },
  },
}
