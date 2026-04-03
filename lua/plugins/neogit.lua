-- https://github.com/NeogitOrg/neogit

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "folke/snacks.nvim", -- optional
    -- Conflict resolution workflow:
      --   1. <leader>gc  — open Diffview
      --   2. xh/xl/xb/xa — choose ours/theirs/base/all
      --   3. :w           — save resolved file
      --   4. S            — in file panel, stage all resolved files
      --   5. <leader>gq  — close Diffview
      --   6. In Neogit, r then r to continue rebase
    {
      "sindrets/diffview.nvim",
      opts = function()
        local actions = require("diffview.actions")
        return {
          view = {
            merge_tool = {
              layout = "diff3_mixed",
              disable_diagnostics = true,
            },
          },
          keymaps = {
            view = {
              { "n", "xh", actions.conflict_choose("ours"), { desc = "Conflict Choose Ours (Left)" } },
              { "n", "xl", actions.conflict_choose("theirs"), { desc = "Conflict Choose Theirs (Right)" } },
              { "n", "xb", actions.conflict_choose("base"), { desc = "Conflict Choose Base" } },
              { "n", "xa", actions.conflict_choose("all"), { desc = "Conflict Choose All" } },
            },
          },
        }
      end,
    },
  },
  keys = {
    { "<C-M-g>", require("git").toggle_neogit, desc = "Toggle Neogit" },
    { "<leader>gN", require("git").new_branch, desc = "[G]it [N]ew Branch" },
    { "<leader>gO", ":Git pr view --web<CR>", desc = "[G]it - [O]pen PR in browser" },
    { "<leader>gp", ":Git publish<CR>", desc = "[G]it [P]ublish" },
    { "<leader>gP", ":Git pr list --web<CR>", desc = "[G]it - List open [P]Rs in browser" },
    { "<leader>gR", ":Git pr create --web --fill-first<CR>", desc = "[G]it - Create pull [r]equest" },
    { "<leader>gt", ":Git trunk<CR>", desc = "[G]it - Switch to [t]runk branch" },
    { "<leader>gT", ":Git retrunk<CR>", desc = "[G]it - Rebase Against [t]runk branch" },
    { "<leader>gs", ":Git sync<CR>", desc = "[G]it Sync" },
    { "<leader>gS", ":Git shove<CR>", desc = "[G]it Shove" },
    { "<leader>gU", ":Git unwip<CR>", desc = "[G]it un-WIP" },
    { "<leader>gW", ":Git wip<CR>", desc = "[G]it WIP" },
    { "<leader>gc", ":DiffviewOpen<CR>", desc = "[G]it [C]onflict Resolution" },
    { "<leader>gq", ":DiffviewClose<CR>", desc = "[G]it - [Q]uit Diffview" },
  },
  config = function()
    require("neogit").setup({
      -- Neogit configuration
      integrations = {
        diffview = true,
        snacks = true,
      },
      -- Customize the Neogit interface
      graph_style = "unicode",
      -- Use single column layout (similar to fugitive)
      kind = "replace",
    })
  end,
}
