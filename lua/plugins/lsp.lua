-- https://github.com/neovim/nvim-lspconfig

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    -- Add shims to the $PATH, if they're not already there
    local shims_dir = require("common").shims_dir
    vim.env.PATH = vim.fn.expand(shims_dir) .. ":" .. vim.env.PATH

    vim.diagnostic.config({
      update_in_insert = false,
      severity_sort = true,
      -- signs are set up in signs.lua
      virtual_lines = { current_line = true },
      float = {
        source = "always",
      },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_buffer", { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
          return
        end

        local bufnr = event.buf
        local map = function(mode, l, r, opts)
          opts = opts or {}
          opts.silent = true
          opts.buffer = bufnr

          if opts.desc then
            opts.desc = "LSP - " .. opts.desc
          end

          vim.keymap.set(mode, l, r, opts)
        end

        map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
        map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
        -- Using snacks for these
        -- map("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
        -- map("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto d[E]claration" })
        -- map("n", "gi", vim.lsp.buf.implementation, { desc = "[G]oto [I]mplementation" })
        -- map("n", "gr", vim.lsp.buf.references, { desc = "[G]oto [R]eferences" })
        -- map("n", "gy", vim.lsp.buf.type_definition, { desc = "[G]oto t[Y]pe definition" })
        -- map("n", "g]", require("telescope.builtin").lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })
        -- map("n", "g}", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })

        -- -- See `:help K` for why this keymap
        -- Replaced functionality with hover.nvim
        -- map("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
        -- map("n","<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })

        -- Inlay hints
        if client.server_capabilities.inlayHintProvider then
          vim.notify_once(client.name .. " supports inlay hints")
          map("n", "<leader>TI", function()
            local new_state = not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.notify("Inlay hinting: " .. tostring(new_state))
            vim.lsp.inlay_hint.enable(new_state, { bufnr = bufnr })
          end, { desc = "[T]oggle [I]nlay Hints" })

          map("n", "<leader>TD", function()
            if vim.diagnostic.config().virtual_lines then
              vim.diagnostic.config({ virtual_lines = false })
              vim.notify("Virtual Diagnostics: False")
            else
              vim.diagnostic.config({ virtual_lines = { current_line = true } })
              vim.notify("Virtual Diagnostics: True")
            end
          end, { desc = "[T]oggle Virtual Line [D]iagnostics" })

          if vim.lsp.inlay_hint then
            vim.g.inlay_hints_visible = true
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

    for _, lsp in ipairs(require("tools").language_servers) do
      local custom = { "basedpyright", "gopls", "ruby_lsp", "ty" }
      if not require("util").has_value(custom, lsp) then
        vim.lsp.enable(lsp)
      end
    end

    require("lspconfig").basedpyright.setup({
      capabilities = capabilities,
      settings = {
        basedpyright = {
          disableOrganizeImports = true, -- using ruff
          analysis = {
            ignore = { "*" }, -- using ruff
            typeCheckingMode = "off", -- using ty
            inlayHints = {
              variableTypes = false, -- conflicts with ty
              callArgumentNames = false, -- conflicts with ty
              functionReturnTypes = true,
              genericTypes = false, -- conflicts with ty
            },
          },
        },
      },
      on_new_config = function(new_config, dir)
        if require("util").dir_has_file(dir, "poetry.lock") then
          vim.notify_once("Running `basedpyright` with `poetry`")
          new_config.cmd = { "poetry", "run", "basedpyright-langserver", "--stdio" }
        elseif require("util").dir_has_file(dir, "uv.lock") then
          vim.notify_once("Running `basedpyright` with `uv`")
          new_config.cmd = { "uv", "run", "basedpyright-langserver", "--stdio" }
        else
          vim.notify_once("Running `basedpyright` without a virtualenv")
        end
      end,
    })

    require("lspconfig").gopls.setup({
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

    require("lspconfig").ruby_lsp.setup({
      capabilities = capabilities,
      on_new_config = function(cfg)
        cfg.cmd = { vim.fn.expand(shims_dir .. "ruby-lsp") }
      end,
    })

    -- Function to set up the ty language server
    local function start_ty()
      -- Find the root directory for the project
      local root_files = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git",
        "poetry.lock",
      }

      local root_dir = vim.fs.dirname(vim.fs.find(root_files, {
        upward = true,
        stop = vim.uv.os_homedir(),
      })[1] or ".")

      -- Determine the command based on whether poetry.lock exists
      local cmd
      if require("util").dir_has_file(root_dir, "poetry.lock") then
        vim.notify_once("Running `ty` with `poetry`")
        cmd = { "poetry", "run", "uvx", "ty", "server" }
      elseif require("util").dir_has_file(root_dir, "uv.lock") then
        vim.notify_once("Running `ty` with `uv`")
        cmd = { "uv", "run", "uvx", "ty", "server" }
      else
        vim.notify_once("Running `ty` without a virtualenv")
        cmd = { "uvx", "ty", "server" }
      end

      -- Start the LSP server
      vim.lsp.start({
        name = "ty",
        cmd = cmd,
        root_dir = root_dir,
        -- Include your existing capabilities
        capabilities = capabilities,
        -- Add any additional settings
        settings = {
          ty = {
            experimental = {
              completions = {
                enable = true,
              },
            },
          },
        },
      })
    end

    -- Set up autocommand to start the server when opening Python files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "python" },
      callback = function()
        start_ty()
      end,
    })
  end,
}
