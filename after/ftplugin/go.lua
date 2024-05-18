local function debug_test()
  require("dap-go").debug_test()
end

vim.keymap.set("n", "<leader>td", debug_test, { buffer = 0, desc = "[T]est - Run test with [d]ebugging" })
