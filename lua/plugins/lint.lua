-- https://github.com/mfussenegger/nvim-lint

vim.api.nvim_create_augroup("lint", { clear = true })
local mypy_dirs = {}

return {
  "mfussenegger/nvim-lint",
  config = function()
    -- Customize linters
    -- Super hacky, waiting on response to: https://github.com/mfussenegger/nvim-lint/issues/407
    vim.api.nvim_create_autocmd({ "FileType" }, {
      group = "lint",
      pattern = { "python" },
      callback = function()
        local dir = vim.uv.cwd()
        if vim.tbl_contains(mypy_dirs, dir) then
          return
        else
          table.insert(mypy_dirs, dir)
        end

        local mypy = require("lint").linters.mypy
        require("lspconfig").util.search_ancestors(dir, function(path)
          local pipfile = require("lspconfig").util.path.join(path, "Pipfile")
          local poetry_lock = require("lspconfig").util.path.join(path, "poetry.lock")
          if require("lspconfig").util.path.is_file(poetry_lock) then
            vim.notify_once("Running `mypy` with `poetry`")
            mypy.cmd = "poetry"
            mypy.args = vim.list_extend({ "run", "mypy" }, mypy.args)
          elseif require("lspconfig").util.path.is_file(pipfile) then
            vim.notify_once("Running `mypy` with `pipenv`")
            mypy.cmd = "pipenv"
            mypy.args = vim.list_extend({ "run", "mypy" }, mypy.args)
          else
            vim.notify_once("Running `mypy` without a virtualenv")
          end
        end)
      end,
    })

    require("lint").linters_by_ft = require("tools").linters
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
