if vim.fn.expand("%:e") == "ipynb" then
  if vim.fn.exists(":MoltenInit") > 0 then
    local venv = "python3"
    local venv_info = vim.system({ "poetry", "env", "info" }, { text = false }):wait()

    if venv_info.code == 0 then
      venv = string.match(vim.uv.cwd(), "/.+/(.+)")
    end

    vim.system({ "poetry", "run", "python3", "-m", "ipykernel", "install", "--user", "--name", venv }):wait()
    vim.cmd(("MoltenInit %s"):format(venv))
  else
    vim.notify("Molten is not installed")
  end
end

local ok, quarto = pcall(require, "quarto")
if ok then
  quarto.activate()
end
