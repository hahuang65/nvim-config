-- https://github.com/L3MON4D3/LuaSnip
-- `$TM_*` variables are available.
-- For example, `$TM_FILENAME` to insert the current filename.
-- Also, can use `print(vim.inspect(arg))` to test things.

local ls = require"luasnip"
local types = require"luasnip.util.types"

ls.config.set_config {
  history = true, -- Allows you to jump back into the last snippet, even if you move outside it
  update_events = "TextChanged,TextChangedI", -- Updates snippets as you type
  delete_check_events = "TextChanged",
  enable_autosnippets = true,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = {{"●", "ErrorMsg"}}
			}
		},
		[types.insertNode] = {
			active = {
				virt_text = {{"●", "WarningMsg"}}
			}
		}
	}
}

require("luasnip.loaders.from_lua").lazy_load({paths = "~/.dotfiles/nvim/lua/snippets"})
