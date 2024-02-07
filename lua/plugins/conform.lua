-- https://github.com/stevearc/conform.nvim

local slow_format_filetypes = {}

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    formatters_by_ft = require("tools").formatters,
    format_on_save = function(bufnr)
      local function on_format(err)
        if err and err:match("timeout$") then
          slow_format_filetypes[vim.bo[bufnr].filetype] = true
        end
      end

      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      if slow_format_filetypes[vim.bo[bufnr].filetype] then
        return
      end

      if string.match(vim.api.nvim_buf_get_name(0), ".+/a5/crm/*") then
        return
      end

      return { timeout_ms = 200, lsp_fallback = true, quiet = true }, on_format
    end,

    format_after_save = function(bufnr)
      if not slow_format_filetypes[vim.bo[bufnr].filetype] then
        return
      end
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { lsp_fallback = true }
    end,
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,

  -- This function is optional, but if you want to customize formatters do it here
  config = function(_, opts)
    -- Customize formatters
    local util = require("conform.util")
    util.add_formatter_args(require("conform.formatters.shfmt"), { "--indent", "2" })
    util.add_formatter_args(
      require("conform.formatters.stylua"),
      { "--config-path", vim.fn.expand("$HOME/.stylua.toml") }
    )
    util.add_formatter_args(
      require("conform.formatters.yamlfmt"),
      { "-conf", vim.fn.expand("$HOME/.yamlfmt.yml") }
    )

    require("conform").setup(opts)

    -- Create functions to enable/disable formatting temporarily
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end,
}
