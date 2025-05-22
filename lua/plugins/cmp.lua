-- https://github.com/saghen/blink.cmp

return {
  "saghen/blink.cmp",
  version = "1.*",
  opts = {
    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      -- Show documentation when selecting a completion item
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },

      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = true },

      menu = {
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 2 },
            { "kind" },
            { "source_name" },
          },
        },
      },
    },

    fuzzy = {
      sorts = {
        -- Prioritize exact matches
        "exact",
        -- The rest are the defaults
        "score",
        "sort_text",
      },
    },

    keymap = { preset = "default" },

    signature = {
      enabled = true,

      trigger = {
        show_on_insert = true,
      },

      window = {
        show_documentation = true,
      },
    },

    snippets = { preset = "luasnip" },
    sources = {
      default = { "lsp", "codecompanion", "lazydev", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },
  },
}
