local utils = require("dap_utils")

local function debug_test()
  require("dap").run(utils.ruby_test_line)
end

vim.keymap.set("n", "<leader>td", debug_test, { buffer = 0, desc = "[T]est - Run test with [d]ebugging" })
