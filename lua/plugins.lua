local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  use {'dracula/vim', as = 'dracula'}

  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require'statusline' end,
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function() require('plugin/gitsigns') end
  }

  use {
    'neovim/nvim-lsp',
    config = function() require'plugin/lsp' end
  }

  use {
    'nvim-telescope/telescope.nvim',
    config = function() require'plugin/telescope' end,
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'}
    }
  }

  use {
    'nvim-telescope/telescope-project.nvim',
    config = function() require'telescope'.load_extension('project') end,
    requires = {
      {'nvim-telescope/telescope.nvim'}
    }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() require'plugin/treesitter' end
  }

  use {'sheerun/vim-polyglot'}
  use {'tpope/vim-commentary'}

  use {
    'ttys3/nvim-blamer.lua',
    config = function()
      require'plugin/blamer'
      vim.fn['nvimblamer#auto']()
    end
  }

  use {'vim-test/vim-test'}
  use {'wbthomason/packer.nvim'}
end)
