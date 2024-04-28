-- https://github.com/nvim-treesitter/nvim-treesitter

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "RRethy/nvim-treesitter-endwise",
  },
  build = function()
    pcall(require("nvim-treesitter.install").update({ with_sync = true }))
  end,
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
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
        "python",
        "query",
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
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      endwise = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = "<C-s>",
          node_decremental = "<C-backSpace>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
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
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["cp"] = "@parameter.inner",
          },
          swap_previous = {
            ["cP"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]b"] = "@block.inner",
            ["]c"] = "@class.outer",
            ["]?"] = "@conditional.outer",
            ["]f"] = "@function.outer",
            ["]l"] = "@loop.outer",
            ["]p"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]B"] = "@block.outer",
            ["]C"] = "@class.outer",
            ["]F"] = "@function.outer",
          },
          goto_previous_start = {
            ["[b"] = "@block.inner",
            ["[c"] = "@class.outer",
            ["[?"] = "@conditional.outer",
            ["[f"] = "@function.outer",
            ["[l"] = "@loop.outer",
            ["[p"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["[B"] = "@block.outer",
            ["[C"] = "@class.outer",
            ["[F"] = "@function.outer",
          },
        },
      },
    })
  end,
}
