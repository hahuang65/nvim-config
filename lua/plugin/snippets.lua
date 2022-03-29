-- https://github.com/L3MON4D3/LuaSnip
-- `$TM_*` variables are available.
-- For example, `$TM_FILENAME` to insert the current filename.
-- Also, can use `print(vim.inspect(arg))` to test things.

local ls = require"luasnip"

ls.config.set_config {
  history = true, -- Allows you to jump back into the last snippet, even if you move outside it
  updateevents = "TextChanged,TextChangedI", -- Updates snippets as you type
  enable_autosnippets = true,
}

require("luasnip.loaders.from_lua").lazy_load({paths = "~/.dotfiles/nvim/lua/snippets"})
