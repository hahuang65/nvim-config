-- https://github.com/NickvanDyke/opencode.nvim

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `toggle()`.
    { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
  },
  config = function()
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on `opencode_opts`.
    }

    -- Required for `vim.g.opencode_opts.auto_reload`.
    vim.o.autoread = true

    -- Recommended/example keymaps.
    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "[O]pencode - [A]sk about this" })

    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      require("opencode").select()
    end, { desc = "[O]pencode - [S]elect prompt" })

    vim.keymap.set({ "n", "x" }, "<C-.>", function()
      require("opencode").prompt("@this")
    end, { desc = "Opencode - Add selection/cursor" })

    vim.keymap.set({ "n", "x", "t" }, "<C-,>", function()
      require("opencode").toggle()
    end, { desc = "Toggle Opencode" })

    vim.keymap.set("n", "<leader>oc", function()
      require("opencode").command()
    end, { desc = "[O]pencode - Select [C]ommand" })

    vim.keymap.set("n", "<leader>on", function()
      require("opencode").command("session_new")
    end, { desc = "New session" })

    vim.keymap.set("n", "<leader>oi", function()
      require("opencode").command("session_interrupt")
    end, { desc = "Interrupt session" })

    vim.keymap.set("n", "<leader>oA", function()
      require("opencode").command("agent_cycle")
    end, { desc = "Cycle selected agent" })

    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("messages_half_page_up")
    end, { desc = "Messages half page up" })

    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("messages_half_page_down")
    end, { desc = "Messages half page down" })
  end,
}
