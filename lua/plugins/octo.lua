-- https://github.com/pwntester/octo.nvim

return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "kyazdani42/nvim-web-devicons",
  },
  config = function()
    require("octo").setup()
  end,
}
