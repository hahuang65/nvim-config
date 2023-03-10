-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/j-hui/fidget.nvim
-- https://github.com/jose-elias-alvarez/null-ls.nvim
-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "jose-elias-alvarez/null-ls.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "j-hui/fidget.nvim",
  },
  config = function()
    local servers = {
      "bashls",
      "dockerls",
      "gopls",
      "jsonls",
      "lua_ls",
      "pyright",
      "sqlls",
      "svelte",
      "terraformls",
      "tsserver",
      "vimls",
      "vuels",
    }

    local tools = {
      "autopep8",
      "debugpy",
      "delve",
      "fixjson",
      "goimports",
      "golangci-lint",
      "jsonlint",
      "markdownlint",
      "prettierd",
      "rubocop",
      "ruff",
      "selene",
      "shellcheck",
      "shfmt",
      "sql-formatter",
      "stylua",
      "tflint",
    }

    vim.diagnostic.config({
      update_in_insert = false,
      severity_sort = true,
      virtual_text = false, -- Since we're using lsp_lines
      signs = true,
      virtual_lines = { only_current_line = true },
    })

    local sign = function(opts)
      vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = "",
      })
    end

    for name, icon in pairs(require("statuscolumn").diagnostic_icons) do
      sign({ name = name, text = icon })
    end

    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(client, bufnr)
      -- NOTE: Remember that lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself
      -- many times.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
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

      nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
      nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
      nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
      nmap("g]", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
      nmap("g}", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

      -- See `:help K` for why this keymap
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")
      nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

      -- Formatting keymaps
      nmap("<leader>F", function()
        if client.server_capabilities.documentFormattingProvider then
          vim.lsp.buf.format()
        else
          print("LSP does not support formatting.")
        end
      end, "[F]ormat file")

      vmap("<leader>f", function()
        if client.server_capabilities.documentRangeFormattingProvider then
          vim.lsp.buf.format()
        else
          print("LSP does not support range formatting.")
        end
      end, "[F]ormat range")

      nmap("<leader>f", function()
        if client.server_capabilities.documentRangeFormattingProvider then
          require("util").format_just_edited()
        else
          print("LSP does not support range formatting.")
        end
      end, "[F]ormat most recently edited text")
    end

    require("fidget").setup({
      text = {
        spinner = "dots",
        done = "✓",
      },
    })

    require("mason").setup()
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
      sources = {
        -- Linters
        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.diagnostics.jsonlint,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.rubocop,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.diagnostics.selene.with({
          extra_args = {
            "--config",
            vim.fn.expand("$HOME/.selene.toml"),
          },
        }),

        -- Formatters
        null_ls.builtins.formatting.autopep8,
        null_ls.builtins.formatting.fixjson,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.rubocop,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.sql_formatter,
        null_ls.builtins.formatting.stylua.with({
          extra_args = {
            "--config-path",
            vim.fn.expand("$HOME/.stylua.toml"),
          },
        }),
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
      on_new_config = function(new_config, root_dir)
        local pipfile_exists = require("lspconfig").util.search_ancestors(root_dir, function(path)
          local pipfile = require("lspconfig").util.path.join(path, "Pipfile")
          if require("lspconfig").util.path.is_file(pipfile) then
            return true
          else
            return false
          end
        end)

        if pipfile_exists then
          new_config.cmd = { "pipenv", "run", "pyright-langserver", "--stdio" }
        end
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
    })
  end,
}
