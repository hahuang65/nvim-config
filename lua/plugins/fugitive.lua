-- https://github.com/tpope/vim-fugitive

return {
  "tpope/vim-fugitive",
  keys = {
    { "<leader>gb", require("git").change_branch, desc = "[G]it [b]ranch" },
    { "<leader>gB", ":Git repo view --web<CR>", desc = "[G]it - Open in [b]rowser" },
    { "<leader>gc", ":GV!<CR>", desc = "[G]it [c]ommits (Buffer)" },
    { "<leader>gC", ":GV<CR>", desc = "[G]it [C]ommits (Project)" },
    { "<leader>gg", require("git").toggle_fugitive, desc = "Toggle Fugitive" },
    { "<leader>gl", ":Git log<CR>", desc = "[G]it [L]og" },
    { "<leader>gN", require("git").new_branch, desc = "[G]it [N]ew Branch" },
    { "<leader>gO", ":Git pr view --web<CR>", desc = "[G]it - [O]pen PR in browser" },
    { "<leader>gp", ":Git publish<CR>", desc = "[G]it [P]ublish" },
    { "<leader>gP", ":Git pr list --web<CR>", desc = "[G]it - List open [P]Rs in browser" },
    { "<leader>gR", ":Git pr create --web --fill-first<CR>", desc = "[G]it - Create pull [r]equest" },
    { "<leader>gt", ":Git trunk<CR>", desc = "[G]it - Switch to [t]runk branch" },
    { "<leader>gT", ":Git retrunk<CR>", desc = "[G]it - Rebase Against [t]runk branch" },
    { "<leader>gs", ":Git sync<CR>", desc = "[G]it Sync" },
    { "<leader>gS", ":Git shove<CR>", desc = "[G]it Shove" },
    { "<leader>g[", ":diffget //2 | :diffupdate<CR>", desc = "Conflict Select (Left)" },
    { "<leader>g]", ":diffget //3 | :diffupdate<CR>", desc = "Conflict Select (Right)" },
    {
      "<leader>g?",
      require("git").commits_for_lines,
      desc = "Conflict Select (Right)",
      mode = { "n", "v" },
    },
  },
}
