-- https://github.com/nvim-treesitter/nvim-treesitter

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "bash",
    "css",
    "dockerfile",
    "go",
    "help",
    "html",
    "javascript",
    "json",
    "lua",
    "make",
    "python",
    "ruby",
    "svelte",
    "typescript",
    "vim",
    "yaml"
  },

  highlight = {
    enable = true,
  },

  indent = {
    enable = true
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-Space>',
      node_incremental = '<C-Space>',
      scope_incremental = '<C-s>',
      node_decremental = '<C-backSpace>'
    }
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = { -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
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
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
      },
    }
  }
}
