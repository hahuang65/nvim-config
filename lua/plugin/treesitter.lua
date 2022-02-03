-- https://github.com/nvim-treesitter/nvim-treesitter

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "org" }
  },
  indent = {
    enable = true
  },
  ensure_installed = {
    "bash",
    "css",
    "dockerfile",
    "go",
    "html",
    "json",
    "lua",
    "make",
    "org",
    "python",
    "ruby",
    "rust",
    "toml",
    "vim",
    "vue",
    "yaml"
  }
}
