-- https://github.com/L3MON4D3/LuaSnip

local ls = require"luasnip"
local f = ls.function_node
local s = ls.s
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.config.set_config {
  history = true, -- Allows you to jump back into the last snippet, even if you move outside it
  updateevents = "TextChanged,TextChangedI", -- Updates snippets as you type
  enable_autosnippets = true,
}

ls.snippets = {
  -- `$TM_*` variables are available.
  -- For example, `$TM_FILENAME` to insert the current filename.
  -- Also, can use `print(vim.inspect(arg))` to test things.
  all = { -- Available in all filetypes
    s("curtime",
      f(function()
        return os.date "%H:%M:%S"
      end)
    ),

    s("curdate",
      f(function()
        return os.date "%D"
      end)
    )
  },
  lua = {
    s("req",
      fmt([[local {} = require('{}')]], { f(function(import_name)
        local parts = vim.split(import_name[1][1], ".", true)
        return parts[#parts] or ""
      end, { 1 }), i(1) })
    )
  }
}
