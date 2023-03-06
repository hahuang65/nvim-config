-- https://gitlab.com/yorickpeterse/nvim-window.git

return {
  "https://gitlab.com/yorickpeterse/nvim-window.git",
  keys = {
    {
      "<leader>w",
      function()
        require("nvim-window").pick()
      end,
      desc = "[W]indow picker",
    },
  },
}
