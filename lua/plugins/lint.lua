-- https://github.com/mfussenegger/nvim-lint

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Custom linters
    require("lint").linters.mypy_venv = function()
      local base = require("lint").linters.mypy
      local cmd

      if require("util").cwd_has_file("poetry.lock") then
        vim.notify_once("Running `mypy` with `poetry`")
        cmd = "poetry"
      elseif require("util").cwd_has_file("Pipfile") then
        vim.notify_once("Running `mypy` with `pipenv`")
        cmd = "pipenv"
      else
        vim.notify_once("Running `mypy` without a virtualenv")
      end

      if cmd ~= nil then
        base.cmd = cmd
        base.args = vim.list_extend({ "run", "mypy" }, base.args)
      end

      return base
    end

    require("lint").linters_by_ft = require("tools").linters
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
