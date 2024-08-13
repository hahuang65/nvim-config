vim.g.mapleader = " "

vim.cmd([[ syntax enable ]])
vim.cmd([[ filetype plugin on ]])

-- https://nanotipsforvim.prose.sh/using-pcall-to-make-your-config-more-stable
local function safeRequire(module)
  local success, loadedModule = pcall(require, module)

  if success then
    return loadedModule
  end

  vim.notify("Error loading " .. module)
end

-- Built-ins
safeRequire("netrw")
safeRequire("options")

-- Custom
safeRequire("neovide")
safeRequire("statuscolumn")
safeRequire("terminal")
safeRequire("keymaps")

-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.env.PATH = vim.fn.expand(require("common").shims_dir) .. ":" .. vim.env.PATH

-- This will load plugins specified in lua/plugins/init.lua
-- as well as merge in any other lua/plugins/*.lua files
return require("lazy").setup("plugins")
