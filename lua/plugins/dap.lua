-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/rcarriga/nvim-dap-ui
-- https://github.com/theHamsta/nvim-dap-virtual-text
-- https://github.com/leoluz/nvim-dap-go
-- https://github.com/suketa/nvim-dap-ruby
-- https://github.com/mfussenegger/nvim-dap-python

return {
  "mfussenegger/nvim-dap",
  lazy = false,
  dependencies = {
    -- Technically, these require nvim-dap, but it's just a good way to group the DAP plugins together.
    "leoluz/nvim-dap-go",
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
    "suketa/nvim-dap-ruby",
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    {
      "<F1>",
      function()
        require("dap").continue()
      end,
      mode = { "n", "i" },
      desc = "[D]ebug - Start/Continue [D]ebugger",
    },
    {
      "<F2>",
      function()
        require("dap").step_over()
      end,
      mode = { "n", "i" },
      desc = "[D]ebug - Step [O]ver",
    },
    {
      "<F3>",
      function()
        require("dap").step_into()
      end,
      mode = { "n", "i" },
      desc = "[D]ebug - Step [I]nto",
    },
    {
      "<F6>",
      function()
        require("dap").step_out()
      end,
      mode = { "n", "i" },
      desc = "[D]ebug - Step [O]ut",
    },
    {
      "<F7>",
      function()
        require("dap").toggle_breakpoint()
      end,
      mode = { "n", "i" },
      desc = "[D]ebug - Toggle [B]reakpoint",
    },

    {
      "<F8>",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      mode = { "n", "i" },
      desc = "[D]ebug - Set Conditional [B]reakpoint",
    },

    {
      "<F9>",
      function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end,
      mode = { "n", "i" },
      desc = "[D]ebug - Set [L]og Point",
    },

    {
      "<leader>dc",
      function()
        require("dap").clear_breakpoints()
      end,
      desc = "[D]ebug - [C]lear breakpoints",
    },

    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "[D]ebug - Run [L]ast",
    },
  },
  config = function()
    require("nvim-dap-virtual-text").setup({
      enabled = true,                        -- enable this plugin (the default)
      enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
      highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true,               -- show stop reason when stopped for exceptions
      commented = false,                     -- prefix virtual text with comment string
      only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
      all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
      filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
      -- experimental features:
      virt_text_pos = "eol",                 -- position of virtual text, see `:h nvim_buf_set_extmark()`
      all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil,               -- position the virtual text at a fixed window column (starting from the first text column) ,
      -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    })

    require("dapui").setup({
      icons = { expanded = "▾", collapsed = "▸" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      -- Expand lines larger than the window
      expand_lines = true,
      layouts = {
        {
          elements = {
            "scopes",
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 60,
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 20,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil,  -- These can be integers or a float between 0 and 1.
        max_width = nil,   -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be 'single', 'double' or 'rounded'
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil, -- Can be integer or nil.
      },
    })

    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_exited["dapui_config"] = function(_, body)
      if body["exitCode"] == 0 then
        dapui.close()
      end
    end

    -- https://github.com/catppuccin/nvim#special-integrations
    for name, icon in pairs(require("statuscolumn").debugger_icons) do
      require("util").define_sign({ name = name, text = icon })
    end

    require("dap-go").setup()

    require("dap-ruby").setup()
    dap.configurations.ruby = {
      {
        type = "ruby",
        name = "debug rspec line",
        bundle = "bundle",
        request = "attach",
        command = "rspec",
        script = "${file}",
        port = 38698,
        server = "127.0.0.1",
        options = {
          source_filetype = "ruby",
        },
        localfs = true,
        waiting = 1000,
        current_line = true,
      },
      {
        type = "ruby",
        name = "debug rspec file",
        bundle = "bundle",
        request = "attach",
        command = "rspec",
        script = "${file}",
        port = 38698,
        server = "127.0.0.1",
        options = {
          source_filetype = "ruby",
        },
        localfs = true,
        waiting = 1000,
      },
      {
        -- This doesn't fully work, as it seems to ignore breakpoints,
        -- as well as not being connected to the correct datastores?
        type = "ruby",
        name = "debug rails server",
        bundle = "bundle",
        request = "attach",
        command = "rails",
        script = "server",
        port = 38698,
        server = "127.0.0.1",
        options = {
          source_filetype = "ruby",
        },
        localfs = true,
        waiting = 1000,
      },
      {
        type = "ruby",
        name = "debug file",
        bundle = "",
        request = "attach",
        command = "ruby",
        script = "${file}",
        port = 38698,
        server = "127.0.0.1",
        options = {
          source_filetype = "ruby",
        },
        localfs = true,
        waiting = 1000,
      },
      {
        type = "ruby",
        name = "debug rspec suite",
        bundle = "bundle",
        request = "attach",
        command = "rspec",
        script = "./spec",
        port = 38698,
        server = "127.0.0.1",
        options = {
          source_filetype = "ruby",
        },
        localfs = true,
        waiting = 1000,
      },
    }

    require("dap-python").resolve_python = function()
      local venv_dir = vim.fn.system({ "pipenv", "--venv" }):gsub("\n", "")
      return venv_dir .. "/bin/python"
    end
    require("dap-python").setup("~/.asdf/shims/python")
    require("dap-python").test_runner = "pytest"
  end,
}
