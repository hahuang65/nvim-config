-- https://github.com/olimorris/codecompanion.nvim

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "j-hui/fidget.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        devstral = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "devstral",
            schema = {
              model = {
                default = "devstral:latest",
              },
              num_ctx = {
                default = 16384,
              },
              num_predict = {
                default = -1,
              },
            },
          })
        end,
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              model = {
                default = "claude-sonnet-4-20250514",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "devstral",
        },
        inline = {
          adapter = "devstral",
        },
      },
      extensions = {
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Automatically generate titles for new chats
            auto_generate_title = true,
            -- Auto-delete after 60 days
            expiration_days = 60,
            -- On exiting and entering neovim, don't load the previous chat
            -- I want to be more explicit about opening the correct chat context each time I use AI
            continue_last_chat = false,
            -- When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = true,
            -- Picker interface ("telescope" or "snacks" or "default")
            picker = "snacks",
            ---Enable detailed logging for history extension
            enable_logging = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            -- Save all chats by default
            auto_save = true,
            -- Keymap to save the current chat manually
            save_chat_keymap = "sc",
          },
        },
      },
    })
    require("plugins.codecompanion.spinner"):init()

    vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>A", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set("v", "<C-a>", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd([[cab cc CodeCompanion]])
  end,
}
