-- https://github.com/L3MON4D3/LuaSnip
-- `$TM_*` variables are available.
-- For example, `$TM_FILENAME` to insert the current filename.
-- Also, can use `print(vim.inspect(arg))` to test things.

local ls = require('luasnip')
local types = require('luasnip.util.types')

ls.config.set_config {
  history = true, -- Allows you to jump back into the last snippet, even if you move outside it
  update_events = 'TextChanged,TextChangedI', -- Updates snippets as you type
  delete_check_events = 'TextChanged',
  enable_autosnippets = true,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = {{'●', 'ErrorMsg'}}
			}
		},
		[types.insertNode] = {
			active = {
				virt_text = {{'●', 'WarningMsg'}}
			}
		}
	}
}

require('luasnip.loaders.from_lua').lazy_load({paths = '~/.dotfiles/nvim/lua/snippets'})

vim.keymap.set({'i', 's'}, '<C-k>', function()
  if ls.expand_or_locally_jumpable() then
    ls.expand_or_jump()
  end
end, { desc = 'Expand or jump to next snippet location' })

vim.keymap.set({'i', 's'}, '<C-j>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { desc = 'Jump backwards in snippet' })

vim.keymap.set({'i', 's'}, '<C-l>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { desc = 'Switch between snippet choices' })

vim.keymap.set('n', '<leader>sr', [[<cmd>source $HOME/.dotfiles/nvim/lua/plugin/snippets.lua<CR>]], { desc = '[S]nippets - Reload' })
vim.keymap.set('n', '<leader>se', require('snippets').edit_current_file_type,                       { desc = '[S]nippets - [E]dit current filetype)' })
vim.keymap.set('n', '<leader>sE', require('snippets').edit_with_prompt,                             { desc = '[S]nippets - [E]dit prompt for filetype' })
