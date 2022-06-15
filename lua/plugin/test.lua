-- https://github.com/nvim-neotest/neotest

require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-go")
  }
})
