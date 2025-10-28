return {
  language_servers = {
    -- "basedpyright",
    "bashls",
    "biome",
    "dockerls",
    "emmylua_ls",
    "fish_lsp",
    "gopls",
    "html",
    "jsonls",
    "marksman",
    "postgres_lsp",
    "ruby_lsp",
    "sqlls",
    "svelte",
    "taplo",
    "terraformls",
    "tflint",
    "ts_ls",
    "ty",
    "vimls",
    "vuels",
    "zls",
  },
  formatters = {
    bash = { "shfmt", "shellcheck" },
    css = { "biome" },
    fish = { "fish_indent" },
    go = { "gofumpt", "goimports", "gci" }, -- important that gci comes AFTER goimports so that imports are added THEN sorted.
    hcl = { "packer_fmt" },
    html = { "htmlbeautifier", "prettierd" },
    javascript = { "biome" },
    json = { "fixjson", "biome", "jq" },
    lua = { "stylua" },
    markdown = { "markdownlint", "prettierd" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    ruby = { "rubocop" },
    sh = { "shfmt", "shellcheck" },
    terraform = { "terraform_fmt" },
    toml = { "taplo" },
    typescript = { "biome" },
    vue = { "prettierd" },
    yaml = { "prettierd", "yamlfmt" },
    zig = { "zigfmt" },
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
    python = { "ruff" },
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
    "delve", -- doesn't play nice with Mise shims
    "fish_indent", -- included with a fish install
    "gci", -- doesn't play nice with Mise shims
    "gofmt", -- doesn't play nice with Mise shims
    "gofumpt", -- doesn't play nice with Mise shims
    "goimports", -- doesn't play nice with Mise shims
    "gopls", -- doesn't play nice with Mise shims
    "packer_fmt", -- Subcommand of packer
    "ruff_fix", -- Subcommand of ruff
    "ruff_format", -- Subcommand of ruff
    "ruff_organize_imports", -- Subcommand of ruff
    "terraform_fmt", -- Subcommand of terraform
    "zigfmt", -- Part of Zig
    -- not real formatters, but pseudo-formatters from conform.nvim
    "trim_whitespace",
    "trim_newlines",
    "squeeze_blanks",
  },
  renames = {
    golangcilint = "golangci-lint",
    nixpkgs_fmt = "nixpkgs-fmt",
    sql_formatter = "sql-formatter",
  },
}
