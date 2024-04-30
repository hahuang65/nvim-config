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
    "tsserver",
    "vimls",
    "vuels",
  },
  formatters = {
    bash = { "shfmt", "shellcheck" },
    css = { "prettierd" },
    go = { "gofumpt", "goimports", "gci" }, -- important that gci comes AFTER goimports so that imports are added THEN sorted.
    hcl = { "packer_fmt" },
    html = { "htmlbeautifier", "prettierd" },
    javascript = { "prettierd" },
    json = { "fixjson", "prettierd", "jq" },
    lua = { "stylua" },
    markdown = { "markdownlint", "prettierd" },
    python = { "autoflake", "ruff_fix", "ruff_format" },
    ruby = { "rubyfmt" },
    sh = { "shfmt", "shellcheck" },
    toml = { "taplo" },
    typescript = { "prettierd" },
    vue = { "prettierd" },
    yaml = { "prettierd", "yamlfmt" },
    ["_"] = { "trim_whitespace", "trim_newlines", "squeeze_blanks" },
  },
  linters = {
    bash = { "shellcheck" },
    docker = { "hadolint" },
    git = { "gitlint" },
    go = { "golangcilint" },
    json = { "jsonlint" },
    lua = { "selene" },
    markdown = { "markdownlint" },
    python = { "mypy_venv", "ruff" },
    ruby = { "rubocop" },
    sh = { "shellcheck" },
    sql = { "sqlfluff" },
    terraform = { "tflint" },
    yaml = { "yamllint" },
  },
  debuggers = {
    "debugpy",
    "delve",
  },
  install_blacklist = {
    "gofmt",
    "packer_fmt", -- Subcommand of packer
    "ruff_fix", -- Subcommand of ruff
    "ruff_format", -- Subcommand of ruff
    -- not real formatters, but pseudo-formatters from conform.nvim
    "trim_whitespace",
    "trim_newlines",
    "squeeze_blanks",
  },
  renames = {
    golangcilint = "golangci-lint",
    mypy_venv = "mypy",
    sql_formatter = "sql-formatter",
  },
}
