-- https://github.com/hrsh7th/nvim-cmp

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

      -- For `luasnip` user.
      -- require('luasnip').lsp_expand(args.body)

      -- For `ultisnips` user.
      -- vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-d>']     = cmp.mapping.scroll_docs(-4),
    ['<C-f>']     = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>']     = cmp.mapping.close(),
    ['<Tab>']     = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>']   = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<CR>']      = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'org_mode' },

    -- For vsnip user.
    -- { name = 'vsnip' },

    -- For luasnip user.
    -- { name = 'luasnip' },

    -- For ultisnips user.
    -- { name = 'ultisnips' },

    { name = 'buffer' },
  }
})
