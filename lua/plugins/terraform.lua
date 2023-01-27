-- https://github.com/hashivim/vim-terraform

return {
  "hashivim/vim-terraform",
  ft = "terraform",
  config = function()
    vim.g.terraform_fmt_on_save = 1
  end,
}
