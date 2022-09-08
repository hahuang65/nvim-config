-- https://github.com/wbthomason/packer.nvim

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
  vim.cmd('packadd packer.nvim')
end

return require('packer').startup(function(use) -- Pass `use` in, to avoid LSP warnings: https://github.com/wbthomason/packer.nvim/issues/243
  use { 'airblade/vim-rooter' }

  use { 'catppuccin/nvim',
    as = "catppuccin",
    run = ":CatppuccinCompile",
    config = function() require'plugin/catppuccin' end
  }

  use { 'dstein64/vim-startuptime',
    opt = true,
    cmd = 'StartupTime'
  }

  use { 'folke/tokyonight.nvim',
    config = function() require'plugin/tokyonight' end
  }

  use { 'folke/which-key.nvim',
    config = function() require'plugin/which-key' end
  }

  use { 'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'onsails/lspkind-nvim',
      'saadparwaiz1/cmp_luasnip'
    },
    config = function() require'plugin/completion' end
  }

  use { 'junegunn/gv.vim',
    requires = 'tpope/vim-fugitive'
  }

  use { 'kana/vim-fakeclip',
    cond = function()
      return vim.fn.has("mac") ~= 1 and vim.fn.has("unix") == 1
    end,
    config = function()
      vim.g.fakeclip_provide_clipboard_key_mappings = not vim.fn.empty(vim.env.WAYLAND_DISPLAY)
    end
  }

  use { 'kevinhwang91/nvim-hlslens',
    config = function() require'plugin/hlslens' end
  }

  use { 'kosayoda/nvim-lightbulb',
    config = function() require'plugin/lightbulb' end
  }

  use { 'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() require'plugin/nvim-tree' end
  }

  use { 'L3MON4D3/LuaSnip',
    config = function() require'plugin/snippets' end
  }

  use { 'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function() require'plugin/gitsigns' end
  }

  use { 'ludovicchabant/vim-gutentags',
    config = function() require'plugin/gutentags' end
  }

  use { 'lukas-reineke/indent-blankline.nvim',
    config = function() require'plugin/indentline' end
  }

  use { 'mfussenegger/nvim-dap',
    requires = {
      -- Technically, these require nvim-dap, but it's just a good way to group the DAP plugins together.
      'leoluz/nvim-dap-go',
      'mfussenegger/nvim-dap-python',
      'rcarriga/nvim-dap-ui',
      'suketa/nvim-dap-ruby',
      'theHamsta/nvim-dap-virtual-text',
    },
    config = function() require'plugin/dap' end
  }

  use { 'neovim/nvim-lsp',
    requires = {
      'j-hui/fidget.nvim'
    },
    config = function() require'plugin/lsp' end
  }

  use { 'numToStr/Comment.nvim',
    config = function() require'plugin/comment' end
  }

  use { 'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require'plugin/lualine' end
  }

  use { 'nvim-neotest/neotest',
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "olimorris/neotest-rspec"
    },
    config = function() require'plugin/test' end
  }

  use { 'nvim-orgmode/orgmode',
    requires = {
      'akinsho/org-bullets.nvim'
    },
    config = function() require'plugin/orgmode' end
  }

  use { 'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim'
    },
    config = function() require'plugin/telescope' end
  }

  use { 'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }

  use { 'nvim-telescope/telescope-project.nvim',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function() require'telescope'.load_extension('project') end
  }

  use { 'nvim-treesitter/nvim-treesitter',
    config = function() require'plugin/treesitter' end,
    run = ':TSUpdate'
  }

  use { 'nvim-treesitter/nvim-treesitter-textobjects' }

  use { 'pwntester/octo.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'kyazdani42/nvim-web-devicons',
  },
  config = function () require"plugin/octo" end
}

  use { 'rafcamlet/nvim-luapad',
    opt = true,
    cmd = { 'Luapad', 'LuaRun', 'Lua' }
  }

  use {'ray-x/lsp_signature.nvim'}
  use { 'romainl/vim-cool' }

  use {'stevearc/dressing.nvim',
    config = function() require'plugin/dressing' end
  }

  use { 'tpope/vim-fugitive' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-surround' }

  use { 'wbthomason/packer.nvim' }

  -- Languages

  use { 'fatih/vim-go',
    config = function() require'plugin/go' end,
    ft = "go"
  }

  use { 'hashivim/vim-terraform',
    config = function() require'plugin/terraform' end,
    ft = "terraform"
  }

  use { 'tpope/vim-rails',
    ft = "ruby"
  }
end)
