#/bin/sh

mkdir -p "${HOME}/.config/nvim"

ln -sf "${PWD}/init.vim" "${HOME}/.config/nvim/init.vim"
ln -snf "${PWD}/lua" "${HOME}/.config/nvim/lua"
