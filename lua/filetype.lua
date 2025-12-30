vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    -- Only check files without an extension
    local filename = vim.fn.expand("%:t")
    if filename:match("%.") then
      return
    end

    -- If the first line is a `uv run` shebang, set ft to python
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
    if first_line:match("^#!/usr/bin/env %-S uv run") then
      vim.bo.filetype = "python"
    end
  end,
})
