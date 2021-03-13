# nvim

My personal configuration for [neovim](https://neovim.io/)
I will do my best to comment the configuration file. Feel free to crib/steal this for your own personal use.

## Usage

Run `./install.sh` to link the configuration files to the proper location

When you open `nvim` for the first time, [packer](https://github.com/wbthomason/packer.nvim) should install itself. If it doesn't, please consult their page for instructions.
Then `:PackerSync` should get the plugins to install. Follow instructions for their page for how to use it.

Finally, there are some language servers to install. Instructions are in the `lua/plugin/lsp.lua` file.

Also, consult the official neovim page on usage instructions as well.
