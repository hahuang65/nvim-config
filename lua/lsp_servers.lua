-- Enumerate the LSP servers desired
-- npm install -g bash-language-server
-- npm install -g dockerfile-language-server-nodejs
-- brew install hashicorp/tap/terraform-ls / paru -S terraform-ls
-- pip install 'python-language-server[all]' (run `asdf reshim python` to get the executable accessible)
-- paru -S rust-analyzer
-- npm install -g vls
-- npm install -g vim-language-server
local servers = {
  'bashls',
  'dockerls',
  'pyls',
  'rust_analyzer',
  'solargraph',
  'terraformls',
  'vimls',
  'vuels'
}

return servers
