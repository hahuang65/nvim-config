-- https://github.com/ThePrimeagen/refactoring.nvim

return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "lewis6991/async.nvim",
  },
  lazy = false,
  config = function()
    require("refactoring").setup({
      -- prompt for return type
      prompt_func_return_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
      },
      -- prompt for function parameters
      prompt_func_param_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
      },
    })
    local keymap = vim.keymap

    keymap.set({ "n", "x" }, "<leader>rf", function()
      -- this keymap doesn't select any textobject by default, so you may need to provide one each time you use it.
      require("refactoring").select_refactor()
    end, { desc = "Select refactor" })
  end,
}
