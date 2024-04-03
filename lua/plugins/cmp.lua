-- https://github.com/hrsh7th/nvim-cmp

return {
  "hrsh7th/nvim-cmp",
  lazy = true,
  after = "LuaSnip",
  dependencies = {
    { "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" },
    { "hrsh7th/cmp-path", after = "cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" },
    { "hrsh7th/cmp-nvim-lua", after = "cmp_luasnip" },
    { "onsails/lspkind-nvim", after = "nvim-cmp" },
    { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
  },
  config = function()
    local cmp = require("cmp")
    local border = {
      { "╭", "CmpBorder" },
      { "─", "CmpBorder" },
      { "╮", "CmpBorder" },
      { "│", "CmpBorder" },
      { "╯", "CmpBorder" },
      { "─", "CmpBorder" },
      { "╰", "CmpBorder" },
      { "│", "CmpBorder" },
    }

    cmp.setup({
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ["<C-n>"] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end,
        ["<C-p>"] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end,
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      },

      sources = {
        { name = "nvim_lsp" },
        { name = "otter" },
        { name = "luasnip" },
        { name = "orgmode" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "buffer", keyword_length = 5 },
      },

      experimental = {
        ghost_text = true,
      },

      window = {
        documentation = {
          border = border,
        },
        completion = {
          border = border,
        },
      },

      formatting = {
        format = require("lspkind").cmp_format({
          with_text = true,
          menu = {
            buffer = "[Buffer]",
            luasnip = "[LuaSnip]",
            nvim_lsp = "[LSP]",
            nvim_lua = "[Lua]",
            path = "[Path]",
          },
        }),
      },
    })
  end,
}
