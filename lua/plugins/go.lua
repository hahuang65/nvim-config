-- https://github.com/fatih/vim-go

return {
  "fatih/vim-go",
  ft = "go",
  dependencies = {
    "leoluz/nvim-dap-go",
  },
  keys = {
    { "<leader>td", require("dap-go").debug_test, desc = "[T]est - [D]ebug", buffer = true },
  },
  config = function()
    vim.g["go_jump_to_error"] = 0
    vim.g["go_fmt_fail_silently"] = 1
  end,
}
