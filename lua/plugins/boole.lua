-- https://github.com/nat-418/boole.nvim

return {
  "nat-418/boole.nvim",
  config = {
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
