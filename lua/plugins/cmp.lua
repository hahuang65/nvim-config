-- https://github.com/hrsh7th/nvim-cmp

return {
  "hrsh7th/nvim-cmp",
  lazy = true,
  event = "InsertEnter",
  dependencies = {
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },
    { "onsails/lspkind-nvim" },
    { "saadparwaiz1/cmp_luasnip" },
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

    -- Until https://github.com/hrsh7th/nvim-cmp/issues/1716
    -- (cmp.ConfirmBehavior.MatchSuffix) gets implemented, use this local wrapper
    -- to choose between `cmp.ConfirmBehavior.Insert` and
    -- `cmp.ConfirmBehavior.Replace`:
    local confirm = function(entry)
      local behavior = cmp.ConfirmBehavior.Replace
      if entry then
        local completion_item = entry.completion_item
        local newText = ""
        if completion_item.textEdit then
          newText = completion_item.textEdit.newText
        elseif type(completion_item.insertText) == "string" and completion_item.insertText ~= "" then
          newText = completion_item.insertText
        else
          newText = completion_item.word or completion_item.label or ""
        end

        -- How many characters will be different after the cursor position if we
        -- replace?
        local diff_after = math.max(0, entry.replace_range["end"].character + 1) - entry.context.cursor.col

        -- Does the text that will be replaced after the cursor match the suffix
        -- of the `newText` to be inserted? If not, we should `Insert` instead.
        if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
          behavior = cmp.ConfirmBehavior.Insert
        end
      end
      cmp.confirm({ select = true, behavior = behavior })
    end

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
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          else
            fallback()
          end
        end,
        ["<C-S-n>"] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          else
            fallback()
          end
        end,
        ["<C-p>"] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          else
            fallback()
          end
        end,
        ["<C-S-p>"] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          else
            fallback()
          end
        end,
        ["<C-y>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            local entry = cmp.get_selected_entry()
            confirm(entry)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-S-y>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            local entry = cmp.get_selected_entry()
            confirm(entry)
          else
            fallback()
          end
        end, { "i", "s" }),
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

    -- Only show ghost text at word boundaries, not inside keywords. Based on idea
    -- from: https://github.com/hrsh7th/nvim-cmp/issues/2035#issuecomment-2347186210

    local cmp_cfg = require("cmp.config")

    local toggle_ghost_text = function()
      if vim.api.nvim_get_mode().mode ~= "i" then
        return
      end

      local cursor_column = vim.fn.col(".")
      local current_line_contents = vim.fn.getline(".")
      local character_after_cursor = current_line_contents:sub(cursor_column, cursor_column)

      local should_enable_ghost_text = character_after_cursor == ""
        or vim.fn.match(character_after_cursor, [[\k]]) == -1

      local current = cmp_cfg.get().experimental.ghost_text
      if current ~= should_enable_ghost_text then
        cmp_cfg.set_global({
          experimental = {
            ghost_text = should_enable_ghost_text,
          },
        })
      end
    end

    vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI" }, {
      callback = toggle_ghost_text,
    })
  end,
}
