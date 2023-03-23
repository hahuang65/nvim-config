-- https://github.com/rcarriga/nvim-notify

return {
  "rcarriga/nvim-notify",
  lazy = false,
  config = function()
    vim.notify = require("notify")
  end,
}
