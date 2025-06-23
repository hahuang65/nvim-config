-- This file includes any plugins that don't require any setup or dependencies.
-- Any other plugins will have their own file in lua/plugins/
return {
  { "tpope/vim-repeat", event = { "BufReadPre", "BufNewFile" } },
  { "tpope/vim-surround", event = { "BufReadPre", "BufNewFile" } },
  { "romainl/vim-cool", event = { "BufReadPre", "BufNewFile" } },
  { "direnv/direnv.vim" },
}
