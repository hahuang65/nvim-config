return {
  language_servers = {
    "basedpyright",
    "bashls",
    "dockerls",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "marksman",
    "ruby_lsp",
    "solargraph",
    "sqlls",
    "svelte",
    "taplo",
    "terraformls",
    "ts_ls",
    "vimls",
    "vuels",
  },
  formatters = {
    bash = { "shfmt", "shellcheck" },
    css = { "biome" },
    go = { "gofumpt", "goimports", "gci" }, -- important that gci comes AFTER goimports so that imports are added THEN sorted.
    hcl = { "packer_fmt" },
    html = { "htmlbeautifier", "prettierd" },
    javascript = { "biome" },
    json = { "fixjson", "biome", "jq" },
    lua = { "stylua" },
    markdown = { "markdownlint", "prettierd" },
    nix = { "nixpkgs_fmt" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    ruby = { "rubyfmt" },
    sh = { "shfmt", "shellcheck" },
    terraform = { "terraform_fmt" },
    toml = { "taplo" },
    typescript = { "biome" },
    vue = { "prettierd" },
    yaml = { "prettierd", "yamlfmt" },
    ["_"] = { "trim_whitespace", "trim_newlines", "squeeze_blanks" },
  },
  linters = {
    -- shellcheck is included in bashls
    -- bash = { "shellcheck" },
    css = { "biomejs" },
    docker = { "hadolint" },
    git = { "gitlint" },
    go = { "golangcilint" },
    javascript = { "biomejs" },
    json = { "jsonlint" },
    lua = { "selene" },
    markdown = { "markdownlint" },
    python = { "mypy_venv", "ruff" },
    ruby = { "rubocop" },
    sh = { "shellcheck" },
    sql = { "sqlfluff" },
    terraform = { "tflint" },
    typescript = { "biomejs" },
    yaml = { "yamllint" },
  },
  debuggers = {
    "debugpy",
    "delve",
  },
  install_blacklist = {
    "biomejs", -- This is what nvim-lint calls it. We install `biome`
    "gofmt",
    "packer_fmt", -- Subcommand of packer
    "ruff_fix", -- Subcommand of ruff
    "ruff_format", -- Subcommand of ruff
    "ruff_organize_imports", -- Subcommand of ruff
    "terraform_fmt", -- Subcommand of terraform
    -- not real formatters, but pseudo-formatters from conform.nvim
    "trim_whitespace",
    "trim_newlines",
    "squeeze_blanks",
  },
  renames = {
    golangcilint = "golangci-lint",
    mypy_venv = "mypy",
    nixpkgs_fmt = "nixpkgs-fmt",
    sql_formatter = "sql-formatter",
  },
}
