-- https://github.com/nvim-telescope/telescope.nvim

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build =
      "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
  },
  keys = {
    {
      "<leader>sb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "[S]earch [B]uffers",
    },
    {
      "<leader>sf",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "[S]earch [F]iles",
    },
    {
      "<leader>sh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "[S]earch [H]elp",
    },
    {
      "<leader>sk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "[S]earch [K]eymaps",
    },
    {
      "<leader>*",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "Search current word",
    },
    {
      "<leader>?",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Search current file",
    },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      desc = "Search Project via grep",
    },
    {
      "<leader>sd",
      function()
        require("telescope.builtin").diagnostics({ bufnr = 0 })
      end,
      desc = "[S]earch [D]iagnostics",
    },
  },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        layout_config = {
          horizontal = { preview_width = 0.67 },
        },
        mappings = {
          n = {
            ["<C-g>"] = actions.close,
            ["<C-q>"] = actions.delete_buffer,
          },
          i = {
            ["<C-g>"] = actions.close,
            ["<C-q>"] = actions.delete_buffer,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
          }
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(require("telescope").load_extension, "fzf")

    -- Temporay workaround for bug: https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1510001730
    vim.api.nvim_create_autocmd("WinLeave", {
      callback = function()
        if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
        end
      end,
    })
  end,
}
