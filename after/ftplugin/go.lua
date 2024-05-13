vim.keymap.set("n", "<leader>td", function()
  require("dap-go").debug_test()
end)
