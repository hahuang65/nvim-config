-- https://github.com/neovim/nvim-lspconfig

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    vim.diagnostic.config({
      update_in_insert = false,
      severity_sort = true,
      virtual_text = false, -- Since we're using lsp_lines
      signs = true,
      virtual_lines = { only_current_line = true },
    })

    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(client, bufnr)
      local map = function(keys, func, desc)
        if desc then
          desc = "LSP - " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      map("ge", vim.lsp.buf.declaration, "[G]oto d[E]claration")
      map("gD", vim.lsp.buf.definition, "[G]oto [D]efinition")
      map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
      map("gR", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
      map("gY", vim.lsp.buf.type_definition, "[G]oto t[Y]pe definition")
      map("g]", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
      map("g}", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

      -- See `:help K` for why this keymap
      map("K", vim.lsp.buf.hover, "Hover Documentation")
      map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    for _, lsp in ipairs(require("tools").language_servers) do
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
        if require("util").dir_has_file(dir, "poetry.lock") then
          vim.notify_once("Running `pyright` with `poetry`")
          new_config.cmd = { "poetry", "run", "pyright-langserver", "--stdio" }
        elseif require("util").dir_has_file(dir, "Pipfile") then
          vim.notify_once("Running `pyright` with `pipenv`")
          new_config.cmd = { "pipenv", "run", "pyright-langserver", "--stdio" }
        else
          vim.notify_once("Running `pyright` without a virtualenv")
        end
      end,
    })

    require("lspconfig").ruby_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      on_new_config = function(cfg)
        cfg.cmd = { vim.fn.expand("$HOME/.asdf/shims/ruby-lsp") }
      end,
    })

    -- Setup solargraph separately, as mason ends up installing it to a central location,
    -- which does not guarantee the same set of gems as a project. This makes it better to
    -- install solargraph, rubocop, rubocop-rails, rubocop-performance, rubocop-rspec, standardrb
    -- in the project.
    --   require("lspconfig").solargraph.setup({
    --     on_attach = on_attach,
    --     capabilities = capabilities,
    --     settings = {
    --       solargraph = {
    --         diagnostics = false, -- Handled by rubocop in nvim-lint
    --       },
    --     },
    --     on_new_config = function(new_config, dir)
    --       if require("util").dir_has_file(dir, "Gemfile") then
    --         local gemfile = require("lspconfig").util.path.join(dir, "Gemfile")
    --         if require("util").file_contents_match(gemfile, "solargraph") then
    --           vim.notify_once("Running `solargraph` with bundler")
    --           new_config.cmd = { "bundle", "exec", "solargraph", "stdio" }
    --         else
    --           vim.notify_once("`solargraph` not found in Gemfile")
    --         end
    --       else
    --         vim.notify_once("Running `solargraph` without bundler")
    --       end
    --     end,
    --   })
  end,
}
