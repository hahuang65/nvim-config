-- https://github.com/stevearc/oil.nvim
return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Open parent directory as buffer" },
  },
  cmd = "Oil",
  config = function()
    require("oil").setup({
      columns = { "icon" },
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-s>"] = false,
        ["<C-h>"] = false,
      },
    })
  end,
}
