local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  use { 'airblade/vim-rooter' }

  use { 'akinsho/nvim-toggleterm.lua',
    config = function() require'toggleterm' end
  }

  use { 'dracula/vim', as = 'dracula' }

  use { 'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require'statusline' end,
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  use { 'itchyny/vim-cursorword' }

  use { 'kana/vim-fakeclip',
    cond = function()
      return vim.fn.has("mac") ~= 1 and vim.fn.has("unix") == 1
    end,
    config = function()
      vim.g.fakeclip_provide_clipboard_key_mappings = not vim.fn.empty(vim.env.WAYLAND_DISPLAY)
    end
  }

  use { 'kassio/neoterm',
    config = function() require'plugin/neoterm' end
  }

  use { 'kevinhwang91/nvim-hlslens',
    config = function() require'plugin/hlslens' end
  }

  use { 'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function() require'plugin/gitsigns' end
  }

  use { 'lukas-reineke/indent-blankline.nvim',
    requires = {
      { 'Yggdroot/indentLine' }
    },
    config = function() require'plugin/indentline' end
  }

  use { 'neovim/nvim-lsp',
    config = function() require'plugin/lsp' end
  }

  use { 'nvim-lua/completion-nvim' }

  use { 'nvim-telescope/telescope.nvim',
    config = function() require'plugin/telescope' end,
    requires = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' }
    }
  }

  use { 'nvim-telescope/telescope-project.nvim',
    config = function() require'telescope'.load_extension('project') end,
    requires = {
      { 'nvim-telescope/telescope.nvim' }
    }
  }

  use { 'nvim-treesitter/nvim-treesitter',
    config = function() require'plugin/treesitter' end
  }

  use { 'rafcamlet/nvim-luapad',
    opt = true,
    cmd = { 'Luapad', 'LuaRun', 'Lua' }
  }

  use { "rcarriga/vim-ultest",
    requires = { "vim-test/vim-test" },
    run = ":UpdateRemotePlugins",
    config = function()
      require'plugin/test'
      require'plugin/ultest'
    end
  } 

  use { 'romainl/vim-cool' }
  use { 'sheerun/vim-polyglot' }
  use { 'TaDaa/vimade' }

  use { 'takac/vim-hardtime',
    config = function() require'plugin/hardtime' end
  }

  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-endwise' }
  use { 'tpope/vim-rails' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-surround' }

  use { 'ttys3/nvim-blamer.lua',
    config = function() require'plugin/blamer' end
  }

  use { 'wbthomason/packer.nvim' }
end)
