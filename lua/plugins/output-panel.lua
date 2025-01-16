-- https://github.com/mhanberg/output-panel.nvim

return {
  "mhanberg/output-panel.nvim",
  config = function()
    require("output_panel").setup({
      max_buffer_size = 5000, -- default
    })
  end,
  cmd = { "OutputPanel" },
  keys = {
    {
      "<leader>o",
      vim.cmd.OutputPanel,
      mode = "n",
      desc = "Toggle the output panel",
    },
  },
}
