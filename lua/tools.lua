return {
  language_servers = {
    "bashls",
    "dockerls",
    "gopls",
    "html",
    "jsonls",
    "kotlin_language_server",
    "lua_ls",
    "marksman",
    "pyright",
    "ruby_ls",
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
    go = { "gofmt", "goimports" },
    html = { "htmlbeautifier", "prettierd" },
    javascript = { "prettierd" },
    json = { "fixjson", "prettierd", "jq" },
    kotlin = { "ktlint" },
    lua = { "stylua" },
    markdown = { "markdownlint", "prettierd" },
    python = { "autoflake", "ruff_fix", "ruff_format" },
    ruby = { "rubyfmt" },
    sh = { "shfmt", "shellcheck" },
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
    "kotlin-debug-adapter",
  },
  install_blacklist = {
    "gofmt",
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
    ruby_ls = "ruby-lsp",
    sql_formatter = "sql-formatter",
  },
}
