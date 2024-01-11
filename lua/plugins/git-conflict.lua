-- https://github.com/akinsho/git-conflict.nvim
return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("git-conflict").setup()

    vim.api.nvim_create_autocmd("User", {
      pattern = "GitConflictDetected",
      callback = function()
        vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
        vim.cmd("GitConflictListQf")
      end,
    })
  end,
}
