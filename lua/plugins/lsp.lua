-- https://github.com/neovim/nvim-lspconfig

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- Add shims to the $PATH, if they're not already there
    local shims_dir = require("common").shims_dir
    vim.env.PATH = vim.fn.expand(shims_dir) .. ":" .. vim.env.PATH

    vim.diagnostic.config({
      update_in_insert = false,
      severity_sort = true,
      virtual_text = false, -- Since we're using lsp_lines
      -- signs are set up in signs.lua
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
      map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
      map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
      map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
      map("gy", vim.lsp.buf.type_definition, "[G]oto t[Y]pe definition")
      map("g]", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
      map("g}", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

      -- -- See `:help K` for why this keymap
      -- Replaced functionality with hover.nvim
      -- map("K", vim.lsp.buf.hover, "Hover Documentation")
      -- map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

      if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.notify("LSP supports inlay hints")
        vim.g.inlay_hints_visible = true
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    for _, lsp in ipairs(require("tools").language_servers) do
      local custom = { "gopls", "lua_ls", "basedpyright", "ruby_lsp", "solargraph" }
      if not require("util").has_value(custom, lsp) then
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

    require("lspconfig").gopls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        gopls = {
          ["ui.inlayhint.hints"] = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
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
            library = vim.env.VIMRUNTIME,
            checkThirdParty = false,
          },
          hint = {
            enable = true,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },
        },
      },
    })

    require("lspconfig").basedpyright.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      on_new_config = function(new_config, dir)
        if require("util").dir_has_file(dir, "poetry.lock") then
          vim.notify_once("Running `basedpyright` with `poetry`")
          new_config.cmd = { "poetry", "run", "basedpyright-langserver", "--stdio" }
        else
          vim.notify_once("Running `basedpyright` without a virtualenv")
        end
      end,
    })

    require("lspconfig").ruby_lsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      on_new_config = function(cfg)
        cfg.cmd = { vim.fn.expand(shims_dir .. "ruby-lsp") }
      end,
    })
  end,
}
