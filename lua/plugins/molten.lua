-- https://github.com/benlubas/molten-nvim
return {
  "benlubas/molten-nvim",
  version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
  dependencies = {
    {
      "willothy/wezterm.nvim",
      opts = { create_commands = false },
    },
  },
  build = ":UpdateRemotePlugins",
  init = function()
    vim.g.molten_image_provider = "wezterm"
    vim.g.molten_auto_open_output = false -- Doesn't work with wezterm.nvim
    vim.g.molten_enter_output_behavior = "open_and_enter"
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true
    vim.g.molten_output_win_border = require("signs").border
  end,
  keys = {
    {
      "<leader>no",
      "<CMD>noautocmd MoltenEnterOutput<CR>",
      desc = "Notebook - Open output window",
    },
    {
      "<leader>nx",
      "<CMD>MoltenHideOutput<CR>",
      desc = "Notebook - Close output window",
    },
  },
}
