-- https://github.com/coder/claudecode.nvim

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("claudecode").setup({
      focus_after_send = true,
    })

    local maps = {
      { { "n", "x", "t" }, "<C-,>", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" } },
      { "n", "<C-.>", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Send current buffer to Claude" } },
      { "v", "<C-.>", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" } },
      { "n", "<leader>A", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff from Claude" } },
      { "n", "<leader>X", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff from Claude" } },
    }

    local function set_keymaps()
      for _, map in ipairs(maps) do
        vim.keymap.set(map[1], map[2], map[3], map[4])
      end
    end

    local function del_keymaps()
      for _, map in ipairs(maps) do
        local modes = type(map[1]) == "table" and map[1] or { map[1] }
        for _, mode in ipairs(modes) do
          pcall(vim.keymap.del, mode, map[2])
        end
      end
    end

    if vim.g.ai_backend == "claude" then
      set_keymaps()
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "AiBackendChanged",
      callback = function()
        if vim.g.ai_backend == "claude" then
          set_keymaps()
        else
          del_keymaps()
        end
      end,
    })
  end,
}
