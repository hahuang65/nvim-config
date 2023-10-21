vim.g.mapleader = " "

vim.cmd([[ syntax enable ]])
vim.cmd([[ filetype plugin on ]])

-- Built-ins
require("netrw")
require("options")

-- Custom
require("neovide")
require("statuscolumn")
require("terminal")
require("keymaps")

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

-- This will load plugins specified in lua/plugins/init.lua
-- as well as merge in any other lua/plugins/*.lua files
return require("lazy").setup("plugins")
