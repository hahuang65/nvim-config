-- https://github.com/wbthomason/packer.nvim

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
  vim.cmd('packadd packer.nvim')
end

return require('packer').startup(function()
  use { 'airblade/vim-rooter' }

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

  use {
    'hoob3rt/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require'plugin/lualine' end
  }

  use { 'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
    },
    config = function() require'plugin/completion' end
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

  use { 'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() require'plugin/nvim-tree' end
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

  use { 'neovim/nvim-lsp',
    config = function() require'plugin/lsp' end
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

  use { 'rafcamlet/nvim-luapad',
    opt = true,
    cmd = { 'Luapad', 'LuaRun', 'Lua' }
  }

  use { 'ray-x/lsp_signature.nvim' }
  use { 'romainl/vim-cool' }

  use { 'sunjon/Shade.nvim',
    config = function() require'plugin/shade' end
  }

  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-fugitive' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-unimpaired' }

  use { 'ttys3/nvim-blamer.lua',
    config = function() require'plugin/blamer' end
  }

  use { 'wbthomason/packer.nvim' }

  -- Languages

  use { 'hashivim/vim-terraform',
    config = function() require'plugin/terraform' end
  }

  use {
    'kchmck/vim-coffee-script',
    ft = { 'coffee' }
  }

  use { 'tpope/vim-rails' }
end)
