-- https://github.com/nvim-neotest/neotest

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-python",
    "fredrikaverpil/neotest-golang",
    "olimorris/neotest-rspec",
  },
  keys = {
    {
      "<leader>tp",
      function()
        require("neotest").run.run({ suite = true })
      end,
      desc = "[T]est [P]roject",
    },

    {
      "<leader>ta",
      function()
        require("neotest").run.attach()
      end,
      desc = "[T]est - [A]ttach to current run",
    },

    {
      "<leader>td",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "[T]est - Run test with [d]ebugging",
    },

    {
      "<leader>tf",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "[T]est [F]ile",
    },

    {
      "<leader>tO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "[T]est - Show [o]utput panel",
    },

    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true })
      end,
      desc = "[T]est - Show individual [O]utput",
    },

    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "[T]est - Open [s]ummary window",
    },
    {
      "<leader>tS",
      function()
        require("neotest").run.stop()
      end,
      desc = "[T]est - [S]top current run",
    },
    {
      "<leader>tt",
      function()
        require("neotest").run.run()
      end,
      desc = "[T]est - Run neares[t]",
    },
    {
      "<leader>tT",
      function()
        require("neotest").run.run_last()
      end,
      desc = "[T]est - re-run las[t]",
    },

    -- `f/F` textobject is taken by `function` in LSP
    {
      "[x",
      function()
        require("neotest").jump.prev({ status = "failed" })
      end,
      desc = "Jump to previous failed test",
    },

    {
      "]x",
      function()
        require("neotest").jump.next({ status = "failed" })
      end,
      desc = "Jump to next failed test",
    },
  },
  config = function()
    require("neotest").setup({
      floating = {
        border = "rounded",
        max_height = 0.75,
        max_width = 0.9,
        options = {},
      },
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
        }),
        require("neotest-golang"),
        require("neotest-rspec"),
      },
    })
  end,
}
