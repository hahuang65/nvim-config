-- https://github.com/nvim-treesitter/nvim-treesitter

local branch = "main"

--- Register parsers from opts.ensure_installed
local function register(ensure_installed)
  for filetype, parser in pairs(ensure_installed) do
    local filetypes = vim.treesitter.language.get_filetypes(parser)
    if not vim.tbl_contains(filetypes, filetype) then
      table.insert(filetypes, filetype)
    end

    -- register and start parsers for filetypes
    vim.treesitter.language.register(parser, filetypes)
  end
end

--- Install and start parsers for nvim-treesitter.
local function install_and_start()
  -- Auto-install and start treesitter parser for any buffer with a registered filetype
  vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    callback = function(event)
      local bufnr = event.buf
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

      -- Skip if no filetype
      if filetype == "" then
        return
      end

      -- Get parser name based on filetype
      local parser_name = vim.treesitter.language.get_lang(filetype) -- WARNING: might return filetype (not helpful)
      if not parser_name then
        -- vim.notify(
        --   "Filetype " .. vim.inspect(filetype) .. " has no parser registered",
        --   vim.log.levels.WARN,
        --   { title = "core/treesitter" }
        -- )
        return
      end

      -- vim.notify(
      --   vim.inspect("Successfully got parser " .. parser_name .. " for filetype " .. filetype),
      --   vim.log.levels.DEBUG,
      --   { title = "core/treesitter" }
      -- )

      -- Check if parser_name is available in parser configs
      local parser_configs = require("nvim-treesitter.parsers")
      if not parser_configs[parser_name] then
        -- vim.notify(
        --   "Parser config does not have parser " .. vim.inspect(parser_name) .. ", skipping",
        --   vim.log.levels.WARN,
        --   { title = "core/treesitter" }
        -- )
        return -- Parser not ailable, skip silently
      end

      local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

      -- If not installed, install parser synchronously
      if not parser_installed then
        require("nvim-treesitter").install({ parser_name }):wait(30000)
        -- vim.notify("Installed parser: " .. parser_name, vim.log.levels.INFO, { title = "core/treesitter" })
      end

      -- Check so tree-sitter can see the newly installed parser
      parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
      if not parser_installed then
        vim.notify(
          "Failed to get parser for " .. parser_name .. " after installation",
          vim.log.levels.WARN,
          { title = "core/treesitter" }
        )
        return
      end

      -- Start treesitter for this buffer
      vim.treesitter.start(bufnr, parser_name)
    end,
  })
end

local function set_foldexpr()
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
end

local function set_indentexpr()
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

local function register_keymaps()
  -- You can use the capture groups defined in textobjects.scm

  local select_keymaps = {
    ["ap"] = "@parameter.outer",
    ["ip"] = "@parameter.inner",
    ["ab"] = "@block.outer",
    ["ib"] = "@block.inner",
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    ["al"] = "@loop.outer",
    ["il"] = "@loop.inner",
    ["a?"] = "@conditional.outer",
    ["i?"] = "@conditional.inner",
    ["a="] = "@assignment.outer",
    ["l="] = "@assignment.lhs",
    ["i="] = "@assignment.inner",
    ["r="] = "@assignment.rhs",
  }
  for keymap, textobject in pairs(select_keymaps) do
    vim.keymap.set({ "x", "o" }, keymap, function()
      require("nvim-treesitter-textobjects.select").select_textobject(textobject, "textobjects")
    end)
  end

  -- Swap
  vim.keymap.set("n", "cp", function()
    require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
  end)
  vim.keymap.set("n", "cP", function()
    require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
  end)

  -- Move
  local goto_next_start_keymaps = {
    ["]b"] = "@block.inner",
    ["]c"] = "@class.outer",
    ["]?"] = "@conditional.outer",
    ["]f"] = "@function.outer",
    ["]l"] = "@loop.outer",
    ["]p"] = "@parameter.inner",
  }
  for keymap, textobject in pairs(goto_next_start_keymaps) do
    vim.keymap.set({ "n", "x", "o" }, keymap, function()
      require("nvim-treesitter-textobjects.move").goto_next_start(textobject, "textobjects")
    end)
  end

  local goto_next_end_keymaps = {
    ["]B"] = "@block.outer",
    ["]C"] = "@class.outer",
    ["]F"] = "@function.outer",
  }
  for keymap, textobject in pairs(goto_next_end_keymaps) do
    vim.keymap.set({ "n", "x", "o" }, keymap, function()
      require("nvim-treesitter-textobjects.move").goto_next_end(textobject, "textobjects")
    end)
  end

  local goto_previous_start_keymaps = {
    ["[b"] = "@block.inner",
    ["[c"] = "@class.outer",
    ["[?"] = "@conditional.outer",
    ["[f"] = "@function.outer",
    ["[l"] = "@loop.outer",
    ["[p"] = "@parameter.inner",
  }
  for keymap, textobject in pairs(goto_previous_start_keymaps) do
    vim.keymap.set({ "n", "x", "o" }, keymap, function()
      require("nvim-treesitter-textobjects.move").goto_previous_start(textobject, "textobjects")
    end)
  end

  local goto_previous_end_keymaps = {
    ["[B"] = "@block.outer",
    ["[C"] = "@class.outer",
    ["[F"] = "@function.outer",
  }
  for keymap, textobject in pairs(goto_previous_end_keymaps) do
    vim.keymap.set({ "n", "x", "o" }, keymap, function()
      require("nvim-treesitter-textobjects.move").goto_previous_end(textobject, "textobjects")
    end)
  end

  local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

  -- Repeat movement with ; and ,
  -- ensure ; goes forward and , goes backward regardless of the last direction
  vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
  vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

  -- vim way: ; goes to the direction you were moving.
  -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
  -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

  -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
  vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = branch,
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = branch },
      "RRethy/nvim-treesitter-endwise",
    },
    config = function()
      set_foldexpr()
      set_indentexpr()

      require("nvim-treesitter-textobjects").setup({
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = false,
        },
        move = {
          -- whether to set jumps in the jumplist
          set_jumps = true,
        },
      })
      register_keymaps()

      register({
        "bash",
        "cooklang",
        "css",
        "csv",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "hcl",
        "html",
        "javascript",
        "jq",
        "json",
        "lua",
        "make",
        "markdown",
        "nix",
        "python",
        "query",
        "regex",
        "ruby",
        "sql",
        "ssh_config",
        "svelte",
        "terraform",
        "toml",
        "typescript",
        "udev",
        "vim",
        "vimdoc",
        "vue",
        "xml",
        "yaml",
      })

      install_and_start()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufRead",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      event = "BufRead",
    },
    opts = {
      multiwindow = true,
    },
  },
}
