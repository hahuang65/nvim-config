-- https://github.com/neovim/nvim-lspconfig

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    local util = require("util")
    -- Add shims to the $PATH, if they're not already there
    local shims_dir = require("common").shims_dir
    vim.env.PATH = vim.fn.expand(shims_dir) .. ":" .. vim.env.PATH

    vim.diagnostic.config({
      update_in_insert = false,
      severity_sort = true,
      -- signs are set up in signs.lua
      virtual_text = false,
      virtual_lines = false, -- { current_line = true },
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

    vim.lsp.config("gopls", {
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

    vim.lsp.config("vuels", {})

    local tools = require("tools")
    for _, lsp in ipairs(tools.language_servers) do
      local custom = { "basedpyright", "pyrefly", "ruby_lsp", "ty" }
      if not util.has_value(custom, lsp) then
        vim.lsp.enable(lsp)
      end
    end

    -- Function to set up the ty language server
    local function start_pytool(name, cmd, settings)
      local function uv_script_python()
        local script = vim.api.nvim_buf_get_name(0)
        local result = vim.system({ "uv", "python", "find", "--script", script }, { text = true }):wait()
        if result.code == 0 then
          return vim.fn.trim(result.stdout)
        end
      end

      if util.has_value(tools.language_servers, name) then
        -- Find the root directory for the project
        local root_dir = util.find_project_root({
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          "poetry.lock",
        })

        local python = uv_script_python()
        if python then
          -- https://www.reddit.com/r/neovim/comments/1lbcjin/pythonuv_script_inline_dependency_with_neovim_lsp/
          vim.notify_once("Running `" .. name .. "` as uv script")
          settings.python = vim.tbl_deep_extend("force", settings.python or {}, { pythonPath = python })
          -- Detect the Python package manager being used, if any
        elseif util.dir_has_file(root_dir, "poetry.lock") then
          vim.notify_once("Running `" .. name .. "` with `poetry`")
          cmd = vim.list_extend({ "poetry", "run" }, cmd)
        elseif util.dir_has_file(root_dir, "uv.lock") then
          vim.notify_once("Running `" .. name .. "` with `uv`")
          cmd = vim.list_extend({ "uv", "run" }, cmd)
        else
          vim.notify_once("Running `" .. name .. "` without a virtualenv")
        end

        -- Start the LSP server
        vim.lsp.start({
          name = name,
          cmd = cmd,
          root_dir = root_dir,
          -- Include your existing capabilities
          capabilities = capabilities,
          -- Add any additional settings
          settings = settings,
        })
      end
    end

    -- Set up autocommand to start the server when opening Python files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "python" },
      callback = function()
        start_pytool("basedpyright", { "basedpyright-langserver", "--stdio" }, {
          basedpyright = {
            disableOrganizeImports = true, -- using ruff
            analysis = {
              ignore = { "*" }, -- using ruff
            },
          },
        })

        start_pytool("ty", { "ty", "server" }, {
          ty = {
            diagnosticMode = "workspace",
            inlayHints = {
              variableTypes = true,
              callArgumentNames = true,
            },
            experimental = {
              rename = true,
            },
          },
        })

        start_pytool("pyrefly", { "pyrefly", "lsp" }, {})
      end,
    })

    -- Set up autocommand to start the server when opening Ruby files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "ruby",
      callback = function()
        local root_dir = vim.fs.dirname(vim.fs.find({ ".git", "Gemfile" }, { upward = true })[1])
        vim.lsp.start({
          name = "ruby_lsp",
          cmd = { vim.fn.expand(shims_dir .. "ruby-lsp") },
          root_dir = root_dir,
          capabilities = capabilities,
        })
      end,
    })
  end,
}
