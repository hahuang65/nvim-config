-- https://github.com/nat-418/boole.nvim

return {
  "nat-418/boole.nvim",
  keys = {
    { "<C-a>", "<cmd>Boole increment<CR>", desc = "Increment using boole.nvim" },
    { "<C-x>", "<cmd>Boole decrement<CR>", desc = "Decrement using boole.nvim" },
  },
  opts = {
    -- Just here because the plugin requires the mappings key
    mappings = {
      increment = "<C-a>",
      decrement = "<C-x>",
    },
    -- User defined loops
    additions = {
      { "foo", "bar", "baz", "qux", "quux", "corge", "grault", "garply", "waldo", "fred", "plugh", "xyzzy" },
    },
    allow_caps_additions = {},
  },
}
