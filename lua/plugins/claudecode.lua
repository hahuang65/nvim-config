-- https://github.com/coder/claudecode.nvim

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  opts = {
    terminal_cmd = "/opt/homebrew/bin/claude",
  },
  keys = {
    { "<C-,>", "<cmd>ClaudeCodeFocus<cr>", mode = { "n", "x", "t" }, desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume conversation with Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue latest conversation with Claude" },
    { "<leader>aM", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<C-.>", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "Send current buffer to Claude" },
    { "<C-.>", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    {
      "<C-.>",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Send file to Claude",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
    },
    -- Diff management
    { "<leader>A", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff from Claude" },
    { "<leader>X", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff from Claude" },
  },
}
