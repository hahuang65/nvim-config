-- https://github.com/DNLHC/glance.nvim

return {
  "dnlhc/glance.nvim",
  keys = {
    {
      "gd",
      "<CMD>Glance definitions<CR>",
      desc = "[G]lance at [D]efinition",
    },
    {
      "gr",
      "<CMD>Glance references<CR>",
      desc = "[G]lance at [R]eferences",
    },
    {
      "gy",
      "<CMD>Glance type_definitions<CR>",
      desc = "[G]lance at t[Y]pe definitions",
    },
    {
      "gi",
      "<CMD>Glance implementations<CR>",
      desc = "[G]lance at i[M]plementations",
    },
  },
  config = function()
    require("glance").setup({
      -- your configuration
    })
  end,
}
