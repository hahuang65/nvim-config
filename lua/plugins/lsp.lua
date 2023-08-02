-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/j-hui/fidget.nvim
-- https://github.com/jose-elias-alvarez/null-ls.nvim
-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim

local augroup = vim.api.nvim_create_augroup("lsp", { clear = true })

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "jose-elias-alvarez/null-ls.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", tag = "legacy" },
  },
  config = function()
    local servers = {
      "bashls",
      "dockerls",
      "gopls",
      "html",
      "jsonls",
      "lua_ls",
      "marksman",
      "pyright",
      "solargraph",
      "sqlls",
      "svelte",
      "taplo",
      "terraformls",
      "tsserver",
      "vimls",
      "vuels",
    }

    local tools = {
      "black",
      "debugpy",
      "delve",
      "fixjson",
      "gitlint",
      "goimports-reviser",
      "golangci-lint",
      "hadolint",
      "htmlbeautifier",
      "jsonlint",
      "jq",
      "markdownlint",
      "mypy",
      "prettierd",
      "rubocop",
      "rubyfmt",
      "ruff",
      "selene",
      "shellcheck",
      "shfmt",
      "sqlfluff",
      "sqlfmt",
      "stylua",
      "tflint",
      "yamlfmt",
      "yamllint",
    }

    vim.diagnostic.config({
      update_in_insert = false,
      severity_sort = true,
      virtual_text = false, -- Since we're using lsp_lines
      signs = true,
      virtual_lines = { only_current_line = true },
    })

    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.notify("Formatting available from " .. client.name)
        vim.api.nvim_create_autocmd("BufWritePre", {
          desc = "Format buffers before saving",
          group = augroup,
          buffer = bufnr,
          callback = function()
            if string.match(vim.api.nvim_buf_get_name(0), ".+/a5/crm/*") then
              return
            end

            vim.lsp.buf.format()
          end,
        })
      end

      if client.supports_method("textDocument/rangeFormatting") then
        vim.notify("Range formatting available from " .. client.name)
      end

      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP - " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      local vmap = function(keys, func, desc)
        if desc then
          desc = "LSP - " .. desc
        end

        vim.keymap.set("v", keys, func, { buffer = bufnr, desc = desc })
      end

      nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      nmap("ge", vim.lsp.buf.declaration, "[G]oto d[E]claration")
      nmap("gD", vim.lsp.buf.definition, "[G]oto [D]efinition")
      nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
      nmap("gR", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
      nmap("gY", vim.lsp.buf.type_definition, "[G]oto t[Y]pe definition")
      nmap("g]", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
      nmap("g}", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

      -- See `:help K` for why this keymap
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")
      nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

      nmap("<leader>F", vim.lsp.buf.format, "[F]ormat file")
      vmap("<leader>f", vim.lsp.buf.format, "[F]ormat range")
      nmap("<leader>f", require("util").format_just_edited, "[F]ormat most recently edited text")
    end

    require("fidget").setup({
      text = {
        spinner = "dots",
        done = "✓",
      },
    })

    require("mason").setup({
      registries = {
        "github:mason-org/mason-registry",
        "github:hahuang65/mason-registry",
      },
    })
    require("mason-lspconfig").setup({
      ensure_installed = servers,
    })
    require("mason-tool-installer").setup({
      ensure_installed = tools,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    for _, lsp in ipairs(servers) do
      local skip = { "lua_ls", "pyright", "solargraph" }
      if not require("util").has_value(skip, lsp) then
        require("lspconfig")[lsp].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end
    end

    -- Make runtime files discoverable to the server
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    local null_ls = require("null-ls")
    null_ls.setup({
      on_attach = on_attach,
      sources = {
        -- Linters
        null_ls.builtins.diagnostics.gitlint,
        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.jsonlint,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.mypy.with({
          command = function()
            local dir = vim.loop.cwd()

            require("lspconfig").util.search_ancestors(dir, function(path)
              local pipfile = require("lspconfig").util.path.join(path, "Pipfile")
              local poetry_lock = require("lspconfig").util.path.join(path, "poetry.lock")
              if require("lspconfig").util.path.is_file(poetry_lock) then
                vim.notify_once("Running `mypy` with `poetry`")
                return "poetry run mypy"
              elseif require("lspconfig").util.path.is_file(pipfile) then
                vim.notify_once("Running `mypy` with `pipenv`")
                return "pipenv run mypy"
              else
                vim.notify_once("Running `mypy` without a virtualenv")
                return "mypy"
              end
            end)
          end,
        }),
        null_ls.builtins.diagnostics.rubocop,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.diagnostics.selene,
        null_ls.builtins.diagnostics.sqlfluff,
        null_ls.builtins.diagnostics.yamllint,

        -- Formatters
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.fixjson,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports_reviser,
        null_ls.builtins.formatting.htmlbeautifier,
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.rubyfmt,
        null_ls.builtins.formatting.shfmt.with({
          extra_args = {
            "--indent",
            "2",
          },
        }),
        null_ls.builtins.formatting.sqlfmt,
        null_ls.builtins.formatting.stylua.with({
          extra_args = {
            "--config-path",
            vim.fn.expand("$HOME/.stylua.toml"),
          },
        }),
        null_ls.builtins.formatting.yamlfmt,
      },
      diagnostics_format = "[#{c}] #{m} (#{s})",
    })

    require("lspconfig").lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT)
            version = "LuaJIT",
            -- Setup your lua path
            path = runtime_path,
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },
        },
      },
    })

    require("lspconfig").pyright.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      on_new_config = function(new_config, dir)
        require("lspconfig").util.search_ancestors(dir, function(path)
          local pipfile = require("lspconfig").util.path.join(path, "Pipfile")
          local poetry_lock = require("lspconfig").util.path.join(path, "poetry.lock")
          if require("lspconfig").util.path.is_file(poetry_lock) then
            vim.notify_once("Running `pyright` with `poetry`")
            new_config.cmd = { "poetry", "run", "pyright-langserver", "--stdio" }
            return true -- Must return true to tell `search_ancestors` to stop iterating.
          elseif require("lspconfig").util.path.is_file(pipfile) then
            vim.notify_once("Running `pyright` with `pipenv`")
            new_config.cmd = { "pipenv", "run", "pyright-langserver", "--stdio" }
            return true -- Must return true to tell `search_ancestors` to stop iterating.
          else
            vim.notify_once("Running `pyright` without a virtualenv")
          end
        end)
      end,
    })

    -- Setup solargraph separately, as mason ends up installing it to a central location,
    -- which does not guarantee the same set of gems as a project. This makes it better to
    -- install solargraph, rubocop, rubocop-rails, rubocop-performance, rubocop-rspec, standardrb
    -- in the project.
    require("lspconfig").solargraph.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        solargraph = {
          diagnostics = false, -- Handled by rubocop in null-ls
        },
      },
      on_new_config = function(new_config, dir)
        require("lspconfig").util.search_ancestors(dir, function(path)
          local gemfile = require("lspconfig").util.path.join(path, "Gemfile")
          if require("lspconfig").util.path.is_file(gemfile) then
            if require("util").file_contents_match(gemfile, "solargraph") then
              vim.notify_once("Running `solargraph` with bundler")
              new_config.cmd = { "bundle", "exec", "solargraph", "stdio" }
              return true -- Must return true to tell `search_ancestors` to stop iterating.
            else
              vim.notify_once("`solargraph` not found in Gemfile")
            end
          else
            vim.notify_once("Running `solargraph` without bundler")
          end
        end)
      end,
    })
  end,
}
