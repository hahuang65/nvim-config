-- https://gitlab.com/yorickpeterse/nvim-window.git

return {
  "https://gitlab.com/yorickpeterse/nvim-window.git",
  keys = {
    {
      "<M-w>",
      function()
        require("nvim-window").pick()
      end,
      mode = { "i", "n", "t", "v" },
      desc = "[W]indow picker",
    },
  },
}
