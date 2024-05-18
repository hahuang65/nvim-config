local function source_file()
  vim.cmd("source %")
  vim.notify("Loaded " .. vim.fn.expand("%"))
end

vim.keymap.set("n", "<leader>X", source_file, { buffer = 0, desc = "Source current file" })
