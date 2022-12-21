-- https://github.com/wbthomason/packer.nvim
--
local bootstrap_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local is_bootstrap = bootstrap_packer()

return require('packer').startup(function(use) -- Pass `use` in, to avoid LSP warnings: https://github.com/wbthomason/packer.nvim/issues/243
  use { 'airblade/vim-rooter' }

  use { 'catppuccin/nvim',
    as = "catppuccin",
    config = function() require('plugins/catppuccin') end
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
    config = function() require('plugins/cmp') end
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
    config = function() require('plugins/hlslens') end
  }

  use { 'L3MON4D3/LuaSnip',
    config = function() require('plugins/luasnip') end
  }

  use { 'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function() require('plugins/gitsigns') end
  }

  use { 'lukas-reineke/indent-blankline.nvim',
    config = function() require('plugins/indent-blankline') end
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
    config = function() require('plugins/dap') end
  }

  use { 'neovim/nvim-lspconfig',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim'
    },
    config = function() require('plugins/lsp') end
  }

  use { 'numToStr/Comment.nvim',
    config = function() require('plugins/comment') end
  }

  use { 'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('plugins/lualine') end
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
    config = function() require('plugins/neotest') end
  }

  use { 'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim'
    },
    config = function() require('plugins/telescope') end
  }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    cond = vim.fn.executable 'make' == 1
  }

  use { 'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    config = function() require('plugins/treesitter') end
  }

  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter'
  }

  use {
    'nvim-treesitter/nvim-treesitter-context',
    after = 'nvim-treesitter'
  }

  use { 'ray-x/lsp_signature.nvim',
    config = function() require('plugins/lsp-signature') end
  }

  use 'romainl/vim-cool'

  use { 'stevearc/dressing.nvim',
    config = function() require('plugins/dressing') end
  }

  use { 'tpope/vim-fugitive',
    config = function() require('plugins/fugitive') end
  }

  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'wbthomason/packer.nvim'

  -- Languages

  use { 'fatih/vim-go',
    ft = "go",
    config = function() require('plugins/go') end
  }

  use { 'hashivim/vim-terraform',
    ft = "terraform",
    config = function() require('plugins/terraform') end
  }

  use { 'tpope/vim-rails',
    ft = "ruby"
  }

  if is_bootstrap then
    require('packer').sync()
    print '=================================='
    print '    Plugins are being installed'
    print '    Wait until Packer completes,'
    print '       then restart nvim'
    print '=================================='
  end
end)
