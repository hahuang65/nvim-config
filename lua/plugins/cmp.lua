-- https://github.com/hrsh7th/nvim-cmp

local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>']     = cmp.mapping.scroll_docs(-4),
    ['<C-f>']     = cmp.mapping.scroll_docs(4),
    ['<C-e>']     = cmp.mapping({
      i           = cmp.mapping.abort(),
      c           = cmp.mapping.close()
    }),
    ['<C-n>']     = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<C-p>']      = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ['<C-y>']     = cmp.mapping.confirm({
        behavior  = cmp.ConfirmBehavior.Replace,
        select    = true,
    })
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'orgmode' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 5 },
  },
  experimental = {
    ghost_text = true
  },
  formatting = {
    format = require'lspkind'.cmp_format({
      with_text = true,
      menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        path = "[Path]"
      })
    })
  }
})
